using System;
//using System.Collections.Generic;
//using System.ComponentModel;
//using System.Data;
using System.Drawing;
//using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net.Sockets;
using System.Net;
using System.IO;
using HexCodec;
using AHcommLib;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI
    {
        public byte timeout = 10; // seconds
        public bool connected = false;
        public bool disconnectNow = false;
        public bool isTimeout = false;
        DateTime lastActivity;

        public TcpClient tcpClient = new TcpClient();
        public NetworkStream networkStream;
        public StreamReader streamReader;
        public StreamWriter streamWriter;

        // UDP socket //
        string senderIP = "127.0.0.255";
        int senderPort = 9000; //Artifical Horizon UDP listening port
        IPEndPoint artificalHorizonUDPEndPoint;
        Socket artificalHorizonUDPSocket;

        
        ///
        /// CONNECTION: ESTABLISHING AND MONITORING
        ///

        private bool Connect()
        {
            //tcpClient = new TcpClient();
            try { tcpClient = new TcpClient(); }
            catch (Exception ex)
            { rtbNetworkLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try
            {
                tcpClient.Connect(IPAddress.Parse(tbIP.Text), Convert.ToInt16(tbPort.Text));
            }
            catch (Exception ex)
            {
                // Log exception
                Console.WriteLine(ex.Message);
                rtbNetworkLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed);
            }
            return tcpClient.Connected;
        }

        private void btConnect_Click(object sender, EventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
            rtbNetworkLog.AppendTextWithTimeStamp("Attemp to connect to the server... " + tbIP.Text + ":" + tbPort.Text, Color.DarkGreen);
            tsStatus.Update("Connecting...", Color.DarkGreen);
            bConnect.Enabled = false;
            this.Update();

            connected = Connect();

            Cursor.Current = Cursors.Default;
            if (connected)
            {
                timerNetworking.Enabled = true; // turn timer on

                connected = true;
                isTimeout = false; // reset time out
                disconnectNow = false; // reset disconnect request
                bDisconnect.Enabled = true;

                rtbNetworkLog.AppendTextWithTimeStamp("Connected.", Color.Blue);
                tsStatus.Update("Connected", Color.Blue);
                
                // UPD socket
                artificalHorizonUDPEndPoint = new IPEndPoint(IPAddress.Parse(senderIP), senderPort);
                artificalHorizonUDPSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);

                lastActivity = DateTime.Now;
            }
            else
            {
                bConnect.Enabled = true;
                bDisconnect.Enabled = false;

                rtbNetworkLog.AppendTextWithTimeStamp("Cannot connect to the server!", Color.Red);
                tsStatus.Update("Not Connected", Color.Red);
            }
        }

        private void btDisconnect_Click(object sender, EventArgs e)
        {
            if (connected)
            {
                timerNetworking.Enabled = false; // turn off timer
                disconnectNow = true; // disconnect request flag on
                // do disconnect
                rtbNetworkLog.AppendTextWithTimeStamp("Disconnecting...", Color.DarkGreen);
                tsStatus.Update("Disconnecting...", Color.DarkGreen);
                try
                {
                    Disconnect();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    rtbNetworkLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed);
                }
            }
        }

        private void Disconnect()
        {
            tcpClient.Close();  
            rtbNetworkLog.AppendTextWithTimeStamp("Disconnected.", Color.Blue);
            tsStatus.Update("Disconnected.");
            rtbNetworkLog.AppendText("====================" + System.Environment.NewLine);
            connected = false;
            bConnect.Enabled = true;
            bDisconnect.Enabled = false;
            timerNetworking.Enabled = false;
        }

        ///
        /// TRANSCEIVER TASK
        ///
        private void TransceiverDoWork()
        {
            timeout = (byte)(upDownTimeout.Value);
            try
            {
                if (connected && (!disconnectNow) && (!isTimeout))
                {
                    // preparing streams
                    networkStream = tcpClient.GetStream();
                    streamReader = new StreamReader(networkStream, Encoding.ASCII);
                    streamWriter = new StreamWriter(networkStream, Encoding.ASCII);

                    ReceiverDoWork();
                    SenderDoWork();
                }
                if (isTimeout)
                {
                    rtbNetworkLog.AppendTextWithTimeStamp("Connection timeout.", Color.Red);
                    tsStatus.Update("Connection timeout", Color.Red);
                    disconnectNow = true;
                }

                if (disconnectNow)
                    Disconnect();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                rtbNetworkLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed);
            }
        }

        private void ReceiverDoWork()
        {
            /// Receiver
            if (networkStream.DataAvailable)
            {
                if (streamReader.Peek() >= 0)
                {
                    tsStatus.Update("Acquiring data...", Color.DarkGray);
                    this.Update();
                    //char inByte = (char) streamReader.Read();
                    rtbNetworkLog.AppendTextWithTimeStamp("Synchronizing...", Color.DarkTurquoise);
                    //while (inByte != '$')
                    while (streamReader.Read() != '$')
                    {
                        //rtbNetworkLog.AppendTextWithTimeStamp("Disposed: " + ((int)inByte).ToString(), Color.DarkTurquoise);
                        //inByte = (char) streamReader.Read();
                        if (DateTime.Now > lastActivity.AddSeconds(timeout))
                        {
                            isTimeout = true;
                            break;
                        }
                    }   // Synchronizer

                    if (!isTimeout)
                    {
                        lastActivity = DateTime.Now;
                        messageReceived = streamReader.ReadLine();

                        if (isLogReceived)
                            rtbReceivedLog.AppendTextWithTimeStamp(messageReceived);

                        // Process Received Data
                        ParseMessage();

                        // Send UDP message
                        BroadcastUDP((int)(eulerAngles[YAW] + 0.5), (int)(eulerAngles[ROLL] + 0.5), (int)(eulerAngles[PITCH] + 0.5), (int)(altitude + 0.5));
                    }
                }
                tsStatus.Update("Ready", Color.DarkGray);
                this.Update();
            }
        }

        private void SenderDoWork()
        {
            /// Sender
            /// only send one at a time to avoid quadricopter buffer overflowing (63 bytes max)
            if ((ordersToSend.Length + gainsToSend[0].Length + gainsToSend[1].Length + gainsToSend[2].Length + modeToSend.Length) > 0)
            {
                bool stop = false;
                tsStatus.Update("Sending data...", Color.DarkGray);
                this.Update();
                streamWriter.Write(STX);                            // 1 byte
                if (isLogSent)
                    rtbSentLog.AppendTextWithTimeStamp("<STX>");
                // STX
                stop = SendBlock(ref ordersToSend); //              // 32+3 bytes
                if (!stop)
                    stop = SendBlock(ref gainsToSend[0]);           // 24+4 bytes
                if (!stop)
                    stop = SendBlock(ref gainsToSend[1]);           // 24+4 bytes
                if (!stop)
                    stop = SendBlock(ref gainsToSend[2]);           // 24+4 bytes
                SendBlock(ref modeToSend);                          // 1+3 bytes
                // EOT
                streamWriter.Write(EOT);                            // 1 byte
                if (isLogSent)
                    rtbSentLog.AppendTextWithTimeStamp("<EOT>");

                streamWriter.Flush();

                tsStatus.Update("Ready", Color.DarkGray);
                this.Update();
            }
        }

        ///
        /// SENDER'S MODULES
        ///
        /// <summary>
        /// Send and log a complete block --- Sample Block: $O[hexString0][hexString1][hexString2][hexString3][ETB].
        /// </summary>
        private bool SendBlock(ref string block)
        {
            if (block.Length > 0)
            {
                streamWriter.Write(block);
                if (isLogSent)
                    rtbSentLog.AppendTextWithTimeStamp(block);
                block = "";
                return true;
            }
            else return false;
        }
        
        /// <summary>
        /// ordersToSend = "$O" + orders[0].ToHexCode() + orders[1].ToHexCode() + orders[2].ToHexCode() + orders[3].ToHexCode() + ETB;
        /// </summary>
        private void UpdateOrdersToSend()
        {
            ordersToSend = "$O" + orders[0].ToHexCode() + orders[1].ToHexCode() + orders[2].ToHexCode() + orders[3].ToHexCode() + ETB;
            //Console.WriteLine(ordersToSend);
        }

        /// <summary>
        /// gainsToSend[channel] = "$G" + channel.ToString() + gainsToSet[channel + 0].ToHexCode() + gainsToSet[channel + 1].ToHexCode() + gainsToSet[channel + 2].ToHexCode() + ETB;
        /// </summary>
        private void UpdateGainsToSend()
        {
            for (byte channel = 0; channel < 3; channel++)
                gainsToSend[channel] = "$G" + channel.ToString() + gainsToSet[channel + 0].ToHexCode() + gainsToSet[channel + 1].ToHexCode() + gainsToSet[channel + 2].ToHexCode() + ETB;
            //Console.WriteLine(gainsToSend[ROLL]);
            //Console.WriteLine(gainsToSend[PITCH]);
            //Console.WriteLine(gainsToSend[YAW]);
        }

        /// <summary>
        /// modeToSend = "$M" + mode.ToString() + ETB
        /// </summary>
        private void UpdateModeToSend()
        {
            modeToSend = "$M" + mode.ToString() + ETB;
            //Console.WriteLine(modeToSend);
        }

        ///
        /// RECEIVER'S MODULES
        /// 
        /// 
        /// Message Parser
        /// 
        private void ParseMessage()
        {
            string[] messages = messageReceived.Split(' ');
            try { micros = UInt32.Parse(messages[0], System.Globalization.NumberStyles.HexNumber); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { eulerAngles[0] = messages[1].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { eulerAngles[1] = messages[2].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { eulerAngles[2] = messages[3].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { altitude = messages[4].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { gpsPosition.time = messages[5].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { gpsPosition.lon = messages[6].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { gpsPosition.lat = messages[7].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { gpsPosition.alt = messages[8].ToFloat(true); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { gpsPosition.sat_num = (byte) Convert.ToUInt16(messages[9], 16); }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
            try { gpsPosition.quality = (byte) Convert.ToUInt16(messages[10], 16);  }
            catch (Exception ex) { rtbReceivedLog.AppendTextWithTimeStamp(ex.Message, Color.DarkRed); }
        }

        ///
        /// UDP SENDER (FOR COMMUNICATING WITH ARTIFICAL HORIZON)
        ///
        private void BroadcastUDP(int heading, int roll, int pitch, int altitude)
        {
            int headerSize = (int)AHcomm.AHsize.header;
            int intRecordSize = (int)AHcomm.AHsize.INT;
            //int fltRecordSize = (int)AHcomm.AHsize.FLOAT;

            byte[] AHheaderV1 = AHcomm.AHheader(1, 1, 1, 0, 1, 0);
            byte[] buff = new byte[headerSize + intRecordSize];
            Buffer.BlockCopy(AHheaderV1, 0, buff, 0, headerSize);

            Buffer.BlockCopy(AHcomm.AHint(AHcomm.AHID.heading, heading), 0, buff, headerSize, intRecordSize);
            artificalHorizonUDPSocket.SendTo(buff, buff.Length, SocketFlags.None, artificalHorizonUDPEndPoint);

            Buffer.BlockCopy(AHcomm.AHint(AHcomm.AHID.roll, roll), 0, buff, headerSize, intRecordSize);
            artificalHorizonUDPSocket.SendTo(buff, buff.Length, SocketFlags.None, artificalHorizonUDPEndPoint);

            Buffer.BlockCopy(AHcomm.AHint(AHcomm.AHID.pitch, pitch), 0, buff, headerSize, intRecordSize);
            artificalHorizonUDPSocket.SendTo(buff, buff.Length, SocketFlags.None, artificalHorizonUDPEndPoint);

            Buffer.BlockCopy(AHcomm.AHint(AHcomm.AHID.altitude, altitude * 100), 0, buff, headerSize, intRecordSize);
            artificalHorizonUDPSocket.SendTo(buff, buff.Length, SocketFlags.None, artificalHorizonUDPEndPoint);
        }
    }    
}
