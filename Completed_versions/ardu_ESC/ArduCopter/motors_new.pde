///This is the main file implementing the new controllers
///The Switch command is the main function, which will switch around controller depending on the chosen controller
/* New functions for a new method to calculate output pwm
/*
/* Modified by NGUYEN Anh Quang
/*
/* Last update 23/4/2015
/*
/**/

///Define variables for each controller
#if using_controller == New_PID_Controller
//IO structure 
t_PIDcontroller_io io;
// State structure
t_PIDcontroller_state state;
#endif



///Initial command for each controller
static inline void init_controller()
{
    switch (using_controller)
    {
        case Original_PID_Controller:
            break;
        
        case New_PID_Controller:
            PIDcontroller_init(&state);
            
            break;
    }
    
    
}

///Declaration to make the program happy
#if using_controller == New_PID_Controller
///PID controller main code
GAREAL* PID_calculate(float z_error, Vector3f output)
{
    double time =(double) millis()/1000.0;
   
    float Kp_z = THROTTLE_ACCEL_P*3.0;
    float Ki_z = THROTTLE_ACCEL_I/10.0;
    float Kd_z = THROTTLE_ACCEL_D;
        
    float Kp_phi = RATE_ROLL_P;
    float Ki_phi = RATE_ROLL_I;
    float Kd_phi = RATE_ROLL_D + 2.0 ;
    
    float Kp_theta = RATE_PITCH_P;
    float Ki_theta = RATE_PITCH_I;
    float Kd_theta = RATE_PITCH_D + 2.0;
 
    float Kp_psi = RATE_YAW_P;
    float Ki_psi = RATE_YAW_I;
    float Kd_psi = RATE_YAW_D +2.0;
    
    float gains[12]=  {Kp_z, Ki_z, Kd_z,
                       Kp_phi, Ki_phi, Kd_phi,
                       Kp_theta, Ki_theta, Kd_theta,
                       Kp_psi, Ki_psi, Kd_psi};
    
    io.t = time;
    for (int i=0; i<12; i++)
      io.gains[i] = gains[i];
    
    io.e[0] = z_error/100.0;
    io.e[1] = output.x/100.0*PI/180.0;
    io.e[2] = output.y/100.0*PI/180.0;
    io.e[3] = output.z/100.0*PI/180.0;    
    //gcs_send_text_fmt(PSTR("z: %f \n"),z_error/100.0);
    
    PIDcontroller_compute(&io,&state);
    
    //gcs_send_text_fmt(PSTR("io.y[0]: %f \n"),io.y[0]);
       
    return io.y;
}
#endif  

///get inputs from the auto mode and then pass it into controllers
///Meaning of the inputs
//  z[0]: current_z      in cm 
//  z[1]: desired_z      in cm
//  z[2]: pos_error_z    in cm
//  angles[0]:  
//  angles[1]:
//  angles[2]:
//  angles[3]:
//  angles[4]:
//  angles[5]:
//  xy_desired.x:
//  xy_desired.y:
//  xy_desired.z:
//  xy_current.x:
//  xy_current.y:
//  xy_current.z:
//  roll :        current roll  radian
//  pitch:        current pitch radian  

void inputs_to_outputs(float* z, float* angles,
                       Vector3f xy_desired, Vector3f xy_current,
                       float roll, float pitch)
{
    if (using_controller != Original_PID_Controller)
    {
        
        GAREAL *rad_per_second;
        //Integrate the calculation for new controllers here
        switch (using_controller)
        {
            case Original_PID_Controller:
                break;
            
            case New_PID_Controller:
                //Inputs: z_error; roll_error; pitch_error; yaw_error
                //Outputs: angular speed of each motors
                Vector3f angle_error;
                angle_error.x = angles[0];
                angle_error.y = angles[1];
                angle_error.z = angles[2];
                //gcs_send_text_fmt(PSTR("r: %f p: %f y: %f \n"),input1,input2,input3);
                //gcs_send_text_fmt(PSTR("z: %f\n"),z_error);
                rad_per_second = PID_calculate(z[2], angle_error);
                
                break;
        }
        motors_output(rad_per_second, roll, pitch);
    }
    else return;    
    
    
}

/// motors_output - send output to motors library which will adjust and send to ESCs and servos
void motors_output(GAREAL *output_value, float roll, float pitch)
{
    // Limits for our quadrotor
    float b = 0.00012; //Ns2
    float d = 0.000003; //Nms2
    float l = 0.225; //m
    float m = 1.14; //kg
    float Torque;
    if ((cos(roll)*cos(pitch)) != 0.0)
    {   
        Torque = (output_value[0] + 9.81)*m/(cos(roll)*cos(pitch));
    }
    else Torque = (output_value[0] + 9.81)*m/(cos(roll)*cos(pitch)+0.001);
    
    //Constrain for io.y
    Torque = constrain_float(Torque, 0, 22.34);
    output_value[1] = constrain_float(output_value[1], -1.257, 1.257); 
    output_value[2] = constrain_float(output_value[2], -1.257, 1.257);
    output_value[3] = constrain_float(output_value[3], -0.279, 0.279);
    
    
    
    double Rotate_speed[4] = {0,0,0,0}; 
    ///Developing X frame
    //Rotate_speed[0] =(double) sqrt(abs(Torque/(4.0*b)-output_value[1]/(4.0*b*l*sqrt(2)/2.0)+output_value[2]/(4.0*b*l*sqrt(2)/2.0)+output_value[3]/(4.0*d)));      //Motor 1
    //Rotate_speed[1] =(double) sqrt(abs(Torque/(4.0*b)+output_value[1]/(4.0*b*l*sqrt(2)/2.0)-output_value[2]/(4.0*b*l*sqrt(2)/2.0)+output_value[3]/(4.0*d)));      //Motor 2
    //Rotate_speed[2] =(double) sqrt(abs(Torque/(4.0*b)+output_value[1]/(4.0*b*l*sqrt(2)/2.0)+output_value[2]/(4.0*b*l*sqrt(2)/2.0)-output_value[3]/(4.0*d)));      //Motor 3
    //Rotate_speed[3] =(double) sqrt(abs(Torque/(4.0*b)-output_value[1]/(4.0*b*l*sqrt(2)/2.0)-output_value[2]/(4.0*b*l*sqrt(2)/2.0)-output_value[3]/(4.0*d)));      //Motor 4
    
    ///Developing + frame
    Rotate_speed[0] =(double) sqrt(abs(Torque/(4.0*b)-output_value[1]/(2.0*b*l)+output_value[3]/(4.0*d)));
    Rotate_speed[1] =(double) sqrt(abs(Torque/(4.0*b)+output_value[1]/(2.0*b*l)+output_value[3]/(4.0*d)));
    Rotate_speed[2] =(double) sqrt(abs(Torque/(4.0*b)+output_value[2]/(2.0*b*l)-output_value[3]/(4.0*d)));
    Rotate_speed[3] =(double) sqrt(abs(Torque/(4.0*b)-output_value[2]/(2.0*b*l)-output_value[3]/(4.0*d)));
    
    
    ///Testing space
    //Rotate_speed[0] =(double) sqrt(fabs(Torque/(4.0*b)));
    //Rotate_speed[1] =(double) sqrt(fabs(Torque/(4.0*b)));
    //Rotate_speed[2] =(double) sqrt(fabs(Torque/(4.0*b)));
    //Rotate_speed[3] =(double) sqrt(fabs(Torque/(4.0*b)));
    
    for (uint8_t i = 0; i<4; i++)
    {
        if (Rotate_speed[i]<=0.0)
            Rotate_speed[i] = 0 ;
        if (Rotate_speed[i]>216.0)
            Rotate_speed[i] = 216.0;        
    }
    
  motors.output_signal(Rotate_speed);
   
  

  
}


   