using System;
using System.Windows.Forms;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI : Form
    {
        private void cbAssisted_CheckedChanged(object sender, EventArgs e)
        {
            cbAuto.Checked = !cbAssisted.Checked;
            //ReadUIMode();
            if (cbAssisted.Checked)
                mode = ASSISTED;
            else
                mode = AUTO;
            UpdateModeToSend();
        }

        private void cbAuto_CheckedChanged(object sender, EventArgs e)
        {
            cbAssisted.Checked = !cbAuto.Checked;
            // this will invoke cbAssisted_CheckedChanged -> updateMode();
        }

        //private void ReadUIMode()
        //{
        //    if (cbAssisted.Checked)
        //        mode = ASSISTED;
        //    else
        //        mode = AUTO;
        //    //Console.WriteLine(mode);
        //}
    }
}