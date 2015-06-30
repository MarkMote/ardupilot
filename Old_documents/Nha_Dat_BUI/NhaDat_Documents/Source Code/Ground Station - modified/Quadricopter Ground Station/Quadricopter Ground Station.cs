using System;
using System.Windows.Forms;
using System.Text;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI : Form
    {
        ///
        /// === Constructor ==========
        ///
        public GroundStationUI()
        {
            InitializeComponent();
            UpdateUIClocks();
            UpdateUIAltitude();
            UpdateUIAttitude();
            UpdateUICurrentGains();
            UpdateUIGainsToSet();
            gainsToSend[0] = "";
            gainsToSend[1] = "";
            gainsToSend[2] = "";
        }

        private void timerInterface_Tick(object sender, EventArgs e)
        {
            UpdateUIClocks();
            UpdateUIAltitude();
            UpdateUIAttitude();
            UpdateUIGPS();
        }

        private void btSaveLog_Click(object sender, EventArgs e)
        {

        }

        private void timerNetworking_Tick(object sender, EventArgs e)
        {
            TransceiverDoWork();
        }

        private void GroundStationUI_FormClosing(object sender, FormClosingEventArgs e)
        {
            disconnectNow = true;
            Disconnect();
            while (connected) { }
        }

        private void timerInterfaceGPS_Tick(object sender, EventArgs e)
        {
            // UpdateMap();
            // http://maps.googleapis.com/maps/api/staticmap?center=46.660865,0.365639&zoom=14&size=330x165&maptype=roadmap&sensor=false

            if (gpsPosition.quality > 0)
            {
                labelNoGPS.Visible = false;
                if ((Math.Abs(46.660865 - gpsPosition.lat) > 0.000001) || (Math.Abs(0.365639 - gpsPosition.lon) > 0.000001))
                {
                    webBrowserSmallMap.Url = new System.Uri(GoogleAPI_GenerateURL(gpsPosition.lon, gpsPosition.lat, 14, 330, 165, false));
                    webBrowserSmallMap.Refresh();
                }
            }
            else
            {
                if (!labelNoGPS.Visible)
                {
                    webBrowserSmallMap.Url = new System.Uri(GoogleAPI_GenerateURL(46.660865f, 0.365639f, 14, 330, 165, false));
                    webBrowserSmallMap.Refresh();
                }
                labelNoGPS.Visible = true;
            }
                
        }

        private string GoogleAPI_GenerateURL(float lon, float lat, float zoom, int sizeW, int sizeH, bool sensor)
        {
            return ("http://maps.googleapis.com/maps/api/staticmap" 
                + "?center=" + lon.ToString() + "," + lat.ToString()
                + "&zoom=" + zoom.ToString()
                + "&size=" + sizeW.ToString() + "x" + sizeH.ToString()
                + "&maptype=raodmap"
                + "&sensor=" + sensor.ToString());
        }
    }
}
