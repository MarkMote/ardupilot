void calculateMotorData(const float *controlSignals, float *motorData)
{
  /*Meaning of the variables in this program
   * controlSignals={Vertical Thrust, Rolling Moment, Pitching Moment, Yawing Moment}
   * d: Drag coefficient of the propeller (Ana's report page 38-39)
   * b: Thrust coefficient of the propeller (Ana's report page 37-38)
   * l: Distance between the Z-axis and the propeller's axis (Ana's report page 35)
   */
  //Variables
    float d=0.000003; //in Nms^2
    float b=0.00012; //in Ns^2
    float l=0.225; //in meters
  // calculation...
  
 
  //The formulas using in this part can be found from Ana's report page 46 (with some modification)
  motorData[0] =  sqrt(1/(4*b)*controlSignals[0]-1/(2*b*l)*controlSignals[2]-1/(4*d)*controlSignals[3]);
  motorData[1] =  sqrt(1/(4*b)*controlSignals[0]-1/(2*b*l)*controlSignals[1]+1/(4*d)*controlSignals[3]);
  motorData[2] =  sqrt(1/(4*b)*controlSignals[0]+1/(2*b*l)*controlSignals[2]-1/(4*d)*controlSignals[3]);
  motorData[3] =  sqrt(1/(4*b)*controlSignals[0]+1/(2*b*l)*controlSignals[1]+1/(4*d)*controlSignals[3]);
}

