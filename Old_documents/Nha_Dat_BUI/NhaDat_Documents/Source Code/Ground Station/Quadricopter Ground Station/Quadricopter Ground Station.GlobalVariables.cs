using System;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI
    {
        ///
        /// === ORDER LIMITATIONS ==========
        ///
        public int[] limMax = { 3, 3, 360 }; // ROLL PITCH YAW
        public int[] limMin = { -3, -3, 0 };
        
///
        /// === STATE VARIABLES ==========
        ///
        /// the current Euler Angles
        public float[] eulerAngles = new float[3];
        /// the current altitude
        public float altitude;
        /// the current GPS informations
        public GPGGA gpsPosition;

        /// the current MCU time (micros) that received from the Quadricopter
        public uint micros = 0;
        /// the time that the Ground Station started
        DateTime startTime = DateTime.Now;

        /// the orders: [ROLL, PITCH, YAW, ALTITUDE]
        public float[] orders = { 0, 0, 0, 0 };
        /// the default gains for quick resetting gains
        public float[] defaultGains = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
        /// the current gains
        public float[] currentGains = { 9, 8, 7, 6, 5, 4, 3, 2, 1 };
        /// the new gains will be sent to the Quadricopter
        public float[] gainsToSet = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        /// the current mode
        public byte mode = ASSISTED; 
        
        ///
        /// === NETWORK VARIABLES ==========
        ///
        public string ordersToSend = "";
        public string[] gainsToSend = new string[3];
        public string modeToSend = "";
        public string messageReceived = "";
    }
}
