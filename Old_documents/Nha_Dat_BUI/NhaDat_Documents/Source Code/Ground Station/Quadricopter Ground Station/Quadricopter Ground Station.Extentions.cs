using System;
using System.Windows.Forms;
using System.Drawing;

namespace Quadricopter_Ground_Station
{
    public static class RichTextBoxExtensions
    {
        public const byte NORMAL = 0;
        public const byte WARNING = 1;
        public const byte ERROR = 2;

        public static void AppendText(this RichTextBox box, string text, Color color)
        {
            box.SelectionStart = box.TextLength;
            box.SelectionLength = 0;

            box.SelectionColor = color;
            box.AppendText(text);
            box.SelectionColor = box.ForeColor;
        }

        public static void AppendTextWithTimeStamp(this RichTextBox rtb, string inString, Color color)
        {
            string timeStamp = "[" + DateTime.Now.TimeOfDay.ToString(@"hh\:mm\:ss\.fff") + "]";
            string logLine = timeStamp + " " + inString + System.Environment.NewLine;
            rtb.AppendText(logLine, color);
        }

        public static void AppendTextWithTimeStamp(this RichTextBox rtb, string inString)
        {
            AppendTextWithTimeStamp(rtb, inString, Color.Black);
        }
    }

	public static class ScrollBarExtentions
    {
        public static int Range(this ScrollBar scrollBar)
        {
            return scrollBar.Maximum - scrollBar.LargeChange + 1 - scrollBar.Minimum;
        }
		public static int Range(this HScrollBar hScrollBar)
        {
            return ((ScrollBar)hScrollBar).Range();
        }
		public static int Range(this VScrollBar vScrollBar)
        {
            return ((ScrollBar)vScrollBar).Range();
        }
    }

	public static class TextBoxExtentions
    {
		public static int Channel(this TextBox textBox)
        {
			string name = textBox.Name.ToUpper();

            if (name.Contains("ROLL"))
                return GroundStationUI.ROLL;
            else if (name.Contains("PITCH"))
                return GroundStationUI.PITCH;
            else if (name.Contains("YAW"))
                return GroundStationUI.YAW;
            else
                return -1;
        }
        public static int PID(this TextBox textBox)
        {
            string name = textBox.Name.ToUpper();

            if (name.Contains("KP"))
                return GroundStationUI.KP;
            else if (name.Contains("KI"))
                return GroundStationUI.KI;
            else if (name.Contains("KD"))
                return GroundStationUI.KD;
            else
                return -1;
        }
    }

    public static class ToolStripStatusLabelExtentions
    {
        public static void Update(this ToolStripLabel toolSripLabel, string inString, Color color)
        {
            toolSripLabel.Text = inString;
            toolSripLabel.ForeColor = color;
        }

        public static void Update(this ToolStripLabel toolSripLabel, string inString)
        {
            Update(toolSripLabel, inString, Color.Black);
        }
    }
}
