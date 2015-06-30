void calculateMotorData(const float *controlSignals, uint16 *motorData)
{
  // calculation...
  motorData[0] = micros();
  motorData[1] = micros();
  motorData[2] = micros();
  motorData[3] = micros();
}

