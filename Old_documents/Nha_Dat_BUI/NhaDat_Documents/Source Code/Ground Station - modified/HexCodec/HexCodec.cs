using System;
namespace HexCodec
{
    public static class Float
    {
        public static float HexToFloat(string hexCode) { return hexCode.ToFloat(false); }
        public static float HexToFloat(string hexCode, bool swapEndianness) { return hexCode.ToFloat(swapEndianness); }
        public static string FloatToHex(float value) { return value.ToHexCode(false); }
        public static string FloatToHex(float value, bool swapEndianness) { return value.ToHexCode(swapEndianness); }
        
        public static float ToFloat(this string hexCode) { return ToFloat(hexCode, false); }
        public static float ToFloat(this string hexCode, bool swapEndianness)
        {
            try
            {
                uint num = uint.Parse(hexCode, System.Globalization.NumberStyles.AllowHexSpecifier);
                byte[] floatVals = BitConverter.GetBytes(num);
                if (swapEndianness) { Array.Reverse(floatVals); }
                return BitConverter.ToSingle(floatVals, 0);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        /// Overload methods

        public static string ToHexCode(this float value) { return ToHexCode(value, false); }
        public static string ToHexCode(this float value, bool swapEndianness)
        {
            try
            {
                byte[] floatVals = BitConverter.GetBytes(value);
                if (swapEndianness) { Array.Reverse(floatVals); }
                return BitConverter.ToString(floatVals).Replace("-", "");
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
