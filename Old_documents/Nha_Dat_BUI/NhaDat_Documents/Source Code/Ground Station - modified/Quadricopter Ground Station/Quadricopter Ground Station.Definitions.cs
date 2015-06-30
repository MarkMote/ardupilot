namespace Quadricopter_Ground_Station
{
    public partial class GroundStationUI
    {
        /* === DEFINITIONS ========= */
        public const byte ROLL     = 0;
        public const byte PITCH    = 1;
        public const byte YAW      = 2;
        public const byte ALTITUDE = 3;
        public const byte KP = 0;
        public const byte KI = 1;
        public const byte KD = 2;

        public const byte ASSISTED = 0;
        public const byte AUTO     = 1;

        public const char STX = '\x02';
        public const char EOT = '\x04';
        public const char ETB = '\x17';

        public struct GPGGA
        {
            public float time ; // HHMMSS.SSS
            public float lat; // DD.DDDDDDD
            public float lon;
            public float alt;
            public byte quality;
            public byte sat_num;
        }
    }
}