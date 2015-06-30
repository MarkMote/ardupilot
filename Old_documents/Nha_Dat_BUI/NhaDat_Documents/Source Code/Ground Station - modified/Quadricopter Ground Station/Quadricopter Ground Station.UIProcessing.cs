using System.Windows.Forms;
using System;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI
    {
        private void UpdateUIClocks()
        {           
            lbCurrentDateTime.Text = DateTime.Now.ToString();
            lbGSTime.Text = (DateTime.Now - startTime).ToString(@"mm\:ss");
            TimeSpan t = TimeSpan.FromMilliseconds(micros/1000);
            lbMicroProcessorTime.Text = t.ToString(@"mm\:ss");
        }

        private void UpdateUIAltitude()
        {
            tbAltitude.Text = altitude.ToString();
        }

        private void UpdateUIAttitude()
        {
            tbRoll.Text = eulerAngles[ROLL].ToString();
            tbPitch.Text = eulerAngles[PITCH].ToString();
            tbYaw.Text = eulerAngles[YAW].ToString();
        }

        private void UpdateUIGPS()
        {
            float time = gpsPosition.time;
            string timeString = time.ToString("F2");
            tbGPSTime.Text = timeString.PadLeft(9,'0');
            tbGPSLong.Text = gpsPosition.lon.ToString();
            tbGPSLat.Text = gpsPosition.lat.ToString();
            tbGPSSatNum.Text = gpsPosition.sat_num.ToString();
            tbGPSQIndex.Text = gpsPosition.quality.ToString();
            tbGPSAlt.Text = gpsPosition.alt.ToString();
        }

        private void UpdateUICurrentGains()
        {
            // K_I_roll = gains[ROLL*3 + KI] ...
            // index = channel*3 + PID
            tbKPRoll.Text = currentGains[ROLL * 3 + KP].ToString();
            tbKIRoll.Text = currentGains[ROLL * 3 + KI].ToString();
            tbKDRoll.Text = currentGains[ROLL * 3 + KD].ToString();
            tbKPPitch.Text = currentGains[PITCH * 3 + KP].ToString();
            tbKIPitch.Text = currentGains[PITCH * 3 + KI].ToString();
            tbKDPitch.Text = currentGains[PITCH * 3 + KD].ToString();
            tbKPYaw.Text = currentGains[YAW * 3 + KP].ToString();
            tbKIYaw.Text = currentGains[YAW * 3 + KI].ToString();
            tbKDYaw.Text = currentGains[YAW * 3 + KD].ToString();
        }

        private void UpdateUIGainsToSet()
        {
            // index = channel*3 + PID
            tbGainsKPRoll.Text = gainsToSet[ROLL * 3 + KP].ToString();
            tbGainsKIRoll.Text = gainsToSet[ROLL * 3 + KI].ToString();
            tbGainsKDRoll.Text = gainsToSet[ROLL * 3 + KD].ToString();
            tbGainsKPPitch.Text = gainsToSet[PITCH * 3 + KP].ToString();
            tbGainsKIPitch.Text = gainsToSet[PITCH * 3 + KI].ToString();
            tbGainsKDPitch.Text = gainsToSet[PITCH * 3 + KD].ToString();
            tbGainsKPYaw.Text = gainsToSet[YAW * 3 + KP].ToString();
            tbGainsKIYaw.Text = gainsToSet[YAW * 3 + KI].ToString();
            tbGainsKDYaw.Text = gainsToSet[YAW * 3 + KD].ToString();
        }

        private void UpdateUIOrdersTextBoxes()
        {
            tbOrdersRoll.Text = orders[ROLL].ToString();
            tbOrdersPitch.Text = orders[PITCH].ToString();
            tbOrdersYaw.Text = orders[YAW].ToString();
        }

        private void UpdateUIOrdersScrollBars()
        {
            ScrollBar currentScrollBar;
            byte channel;

            for (channel = 0; channel < 3; channel++)
            {
                switch (channel)
                {
                    case ROLL:
                        currentScrollBar = (ScrollBar)hScrollBarRoll;
                        break;
                    case PITCH:
                        currentScrollBar = (ScrollBar)hScrollBarPitch;
                        break;
                    case YAW:
                        currentScrollBar = (ScrollBar)hScrollBarYaw;
                        break;
                    default:
                        currentScrollBar = null;
                        break;
                }
                currentScrollBar.Value = (int)((orders[channel] - limMin[channel]) / (limMax[channel] - limMin[channel]) * currentScrollBar.Range() + currentScrollBar.Minimum + 0.5); // +0.5 for rounding up
            }
        }
    }
}