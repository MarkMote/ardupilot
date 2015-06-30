using System;
using System.Windows.Forms;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI : Form
    {       
        private void LoadGainsToSet(float[] inGains)
        {
            Array.Copy(inGains, gainsToSet, 9);
            UpdateUIGainsToSet();
        }

        private void btCurrentValues_Click(object sender, EventArgs e)
        {
            LoadGainsToSet(currentGains);
        }

        private void btDefault_Click(object sender, EventArgs e)
        {
            LoadGainsToSet(defaultGains);
        }

        private void btSet_Click(object sender, EventArgs e)
        {
            // the currentGains will be update through WiFi ?
            Array.Copy(gainsToSet, currentGains, 9);
            UpdateUICurrentGains();
            // update message to send
            UpdateGainsToSend();
            cbGainsTuner.Checked = false;
        }

        private void cbGainsTuner_CheckedChanged(object sender, EventArgs e)
        {
            bool state = cbGainsTuner.Checked;
            // turn on buttons -> copy current gains to gains
            tbGainsKDPitch.Visible = state;
            tbGainsKIPitch.Visible = state;
            tbGainsKPPitch.Visible = state;
            tbGainsKDRoll.Visible = state;
            tbGainsKIRoll.Visible = state;
            tbGainsKPRoll.Visible = state;
            tbGainsKDYaw.Visible = state;
            tbGainsKIYaw.Visible = state;
            tbGainsKPYaw.Visible = state;
            btCurrentValues.Enabled = state;
            btDefault.Enabled = state;
            btSet.Enabled = state;
            if (state)
                LoadGainsToSet(currentGains);
        }

        private void tbGains_Leave(object sender, EventArgs e)
        {
            TextBox currentTextBox = (TextBox)sender;
            int PID = currentTextBox.PID();
            int channel = currentTextBox.Channel();
            int index = GainsIndex((byte)channel, (byte)PID);

            if ((PID > -1) && (channel > -1))
            {
                try
                {
                    float temp = float.Parse(currentTextBox.Text);
                    //if ((temp > limGainsMax[index]) || (temp < limGainsMin[index]))
                    //    currentTextBox.Text = gainsToSet[index].ToString();
                    //else
                    gainsToSet[index] = temp;
                }
                catch
                {
                    currentTextBox.Text = gainsToSet[index].ToString();
                }
            }
            //Console.WriteLine("CG[" + index.ToString() + "] = " + currentGains[index].ToString());
            //Console.WriteLine(" G[" + index.ToString() + "] = " + gainsToSet[index].ToString());
        }

        public int GainsIndex(byte channel, byte PID)
        {
            return channel * 3 + PID;
        }
    }
}
