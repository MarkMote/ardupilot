using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;

namespace AHcommLib
{
    public class AHcomm
    {
        public enum AHID:int
        {
            heading = 1000,
            pitch = 1001,
            roll = 1002,
            altitude = 1010
        }

        public enum AHsize:int
        {
            INT = 9,
            FLOAT = 9,
            header = 15
        }

        public enum AHtypeID:byte
        {
            BOOL = 16,
            INT = 40,
            FLOAT = 84,   //32-bit float ---- double in DIOM
            FLOAT16 = 80,  //16-bit float ---- float in DIOM
            STRING = 120

        }
    
        public static byte[] AHheader(byte VER, int FED, int COM, int STAMP, byte REC, byte OLEN)
        {
            byte[] buff = new byte[(int)AHsize.header];
            // byte VER   //0
            // int FED    //1-4
            // int COM    //5-8
            // int STAMP  //9-12
            // byte REC   //13
            // byte OLEN  //14
            buff[0] = VER;
            buff[13] = REC;
            buff[14] = OLEN;
            byte[] tmp = BitConverter.GetBytes(FED);
            Buffer.BlockCopy(BitConverter.GetBytes(FED), 0, buff, 1, sizeof(int));
            Buffer.BlockCopy(BitConverter.GetBytes(COM), 0, buff, 5, sizeof(int));
            Buffer.BlockCopy(BitConverter.GetBytes(STAMP), 0, buff, 9, sizeof(int));
            return buff;
        }

        public static byte[] AHint(AHID ID, int VAL)
        {
            byte[] buff = new byte[(int)AHsize.INT];
            buff[0] = (byte)AHtypeID.INT;
            Buffer.BlockCopy(BitConverter.GetBytes((int)ID), 0, buff, 1, sizeof(int));
            Buffer.BlockCopy(BitConverter.GetBytes(VAL), 0, buff, 5, sizeof(int));
            return buff;
        }

        public static byte[] AHfloat(AHID ID, float VAL) //32 bit floating point
        {
            byte[] buff = new byte[(int)AHsize.FLOAT];
            buff[0] = (byte)AHtypeID.FLOAT;
            Buffer.BlockCopy(BitConverter.GetBytes((int)ID), 0, buff, 1, sizeof(int));
            Buffer.BlockCopy(BitConverter.GetBytes(VAL), 0, buff, 5, sizeof(int));
            return buff;
        }
    }
}