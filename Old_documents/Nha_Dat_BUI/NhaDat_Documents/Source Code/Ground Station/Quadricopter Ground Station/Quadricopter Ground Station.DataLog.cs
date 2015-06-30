using System;
using System.Windows.Forms;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI : Form
    {
        public bool isLogSent = true;
        public bool isLogReceived = true;

        private void btClearSentData_Click(object sender, EventArgs e)
        {
            rtbSentLog.Clear();
            rtbSentLog.AppendTextWithTimeStamp("<Log Cleared>");
        }

        private void cbLogSentData_CheckedChanged(object sender, EventArgs e)
        {
            isLogSent = cbLogSentData.Checked;
            if (isLogSent)
                rtbSentLog.AppendTextWithTimeStamp("<Log On>");
            else
                rtbSentLog.AppendTextWithTimeStamp("<Log Off>");
        }

        private void btClearReceivedData_Click(object sender, EventArgs e)
        {
            rtbReceivedLog.Clear();
            rtbReceivedLog.AppendTextWithTimeStamp("<Log Cleared>");
        }

        private void cbLogReceivedData_CheckedChanged(object sender, EventArgs e)
        {
            isLogReceived = cbLogReceivedData.Checked;
            if (isLogReceived)
                rtbReceivedLog.AppendTextWithTimeStamp("<Log On>");
            else
                rtbReceivedLog.AppendTextWithTimeStamp("<Log Off>");
        }
    }
}