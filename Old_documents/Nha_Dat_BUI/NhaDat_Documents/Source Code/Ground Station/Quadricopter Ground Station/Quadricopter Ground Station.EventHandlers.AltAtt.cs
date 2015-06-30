using System;
using System.Windows.Forms;

namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI
    {
        private void upDownAltitude_ValueChanged(object sender, EventArgs e)
        {
            orders[ALTITUDE] = (float)(upDownAltitude.Value);
            UpdateOrdersToSend();
        }

        ///
        /// Orders TextBoxes
        ///
        private void tbOrders_Leave(object sender, EventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            float temp;
            int channel = textBox.Channel();
            try
            {
                temp = float.Parse(textBox.Text);
                if ((temp > limMax[channel]) || (temp < limMin[channel]))
                    textBox.Text = orders[channel].ToString();
                else
                    orders[channel] = temp;
            }
            catch
            {
                textBox.Text = orders[channel].ToString();
            }
            UpdateUIOrdersScrollBars();
        }

        ///
        /// Orders ScrollBars
        /// 
        private void ordersScrollBar_Scrolled(object sender, EventArgs e)
        {
            ScrollBar scrollBar = (ScrollBar)sender;
            int channel = new int();
            TextBox textBox = new TextBox();
            switch (scrollBar.Name)
            {
                case "hScrollBarPitch":
                    channel = PITCH;
                    textBox = tbOrdersPitch;
                    break;
                case "hScrollBarRoll":
                    channel = ROLL;
                    textBox = tbOrdersRoll;
                    break;
                case "hScrollBarYaw":
                    textBox = tbOrdersYaw;
                    channel = YAW;
                    break;
            }
            orders[channel] = (float)(scrollBar.Value - scrollBar.Minimum) / (scrollBar.Range()) * (limMax[channel] - limMin[channel]) + limMin[channel];
            UpdateUIOrdersTextBoxes();
            UpdateOrdersToSend();
        }
    }
}