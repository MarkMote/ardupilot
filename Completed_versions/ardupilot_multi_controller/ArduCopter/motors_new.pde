///This is the main file implementing the new controllers
///The Switch command is the main function, which will switch around controller depending on the chosen controller
/* New functions for a new method to calculate output pwm
/*
/* Modified by NGUYEN Anh Quang
/*
/* Last update 23/4/2015
/*
/**/

t_MotorSpeed_io io_motors;

///Define variables for each controller
#if using_controller == New_PID_Controller
//IO structure 
t_PIDcontroller_io io;
// State structure
t_PIDcontroller_state state;
#endif

#if using_controller == Simple_IB_Controller
//IO structure 
t_IB_Controller_ga_attitude_final_io io_attitude;
t_Altitude_io io_alt;
// State structure
t_IB_Controller_ga_attitude_final_state state_attitude;
t_Altitude_state state_alt;
#endif

double Rotate_speed[4] = {0,0,0,0}; 


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
           
        case Simple_IB_Controller:
            IB_Controller_ga_attitude_final_init(&state_attitude);
            Altitude_init(&state_alt);
            break;

    }
    
    
}

///Declaration to make the program happy
#if using_controller == New_PID_Controller
///PID controller main code
GAREAL* PID_calculate(float z_error, Vector3f output, float pitch, float roll)
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
    float m = 1.14; //kg
    
    if ((cos(roll)*cos(pitch)) != 0.0)
    {   
        io.y[0] = (io.y[0] + 9.81)*m/(cos(roll)*cos(pitch));
    }
    else io.y[0] = (io.y[0] + 9.81)*m/(cos(roll)*cos(pitch)+0.001);
    
    //Constrain for io.y
    io.y[0] = constrain_float(io.y[0], 0, 22.34);
    io.y[1] = constrain_float(io.y[1], -1.257, 1.257); 
    io.y[2] = constrain_float(io.y[2], -1.257, 1.257);
    io.y[3] = constrain_float(io.y[3], -0.279, 0.279);
    
    return io.y;
}
#endif

#if using_controller == Simple_IB_Controller
///Integral Backsteping main code
GAREAL IB_results[4];
double time_old = 0;
GAREAL* IB_calculate(float curr_alt, float alt_des, Vector3f angle_cur, Vector3f angular_speed, 
                    Vector3f angles_tar)
{
    double time =(double) millis()/1000.0;
    if (fabs(time-time_old)>1.0)
    {
        time_old = time;
        IB_results[0] = 0;
        IB_results[1] = 0;
        IB_results[2] = 0;
        IB_results[3] = 0;
        return IB_results;
    }
        
    //Get the values

    io_alt.z = curr_alt/100.0;
    io_alt.zd = alt_des/100.0;
     
    
    io_alt.dt = time - time_old;
    io_alt.phi = angle_cur.x;
    io_alt.theta = angle_cur.y;
    
    Altitude_compute(&io_alt,&state_alt);
    if (io_alt.U1 > 6)
        IB_results[0] = io_alt.U1;
    else IB_results[0] = 6;    

    
    io_attitude.angles[0] = angle_cur.x;
    io_attitude.angles[1] = angle_cur.y;
    io_attitude.angles[2] = angle_cur.z;
    io_attitude.angles[3] = angular_speed.x/100.0*PI/180.0;
    io_attitude.angles[4] = angular_speed.y/100.0*PI/180.0;
    io_attitude.angles[5] = angular_speed.z/100.0*PI/180.0;
    io_attitude.dt = time - time_old;
    io_attitude.phid = angles_tar.x/100.0*PI/180.0 + angle_cur.x;
    io_attitude.thetad = angles_tar.y/100.0*PI/180.0 + angle_cur.y;
    io_attitude.psid = angles_tar.z/100.0*PI/180.0;
           
    io_attitude.omgs[0] = Rotate_speed[3];
    io_attitude.omgs[1] = Rotate_speed[0];
    io_attitude.omgs[2] = Rotate_speed[2];
    io_attitude.omgs[3] = Rotate_speed[1];
    
    //gcs_send_text_fmt(PSTR("U1:%f U2:%f U3:%f U4:%f \n"),Rotate_speed[2], Rotate_speed[0], Rotate_speed[3], Rotate_speed[1] );
        
    IB_Controller_ga_attitude_final_compute(&io_attitude,&state_attitude);    
  
    time_old = time;
 
    IB_results[1] = io_attitude.U2;
    IB_results[2] = io_attitude.U3;
    IB_results[3] = io_attitude.U4;

    return IB_results;
}
#endif

///get inputs from the auto mode and then pass it into controllers
///Meaning of the inputs
//  z[0]: current_z      in cm 
//  z[1]: desired_z      in cm
//  z[2]: pos_error_z    in cm
//  z[3]:
//  z[4]: 
//  angles[0]: angle_bf_error (roll)    in centi-degree 
//  angles[1]: angle_bf_error (pitch)   in centi-degree
//  angles[2]: angle_bf_error (yaw)     in centi-degree
//  angles[3]: angle_ef_target (roll)   in centi-degree
//  angles[4]: angle_ef_target (pitch)  in centi-degree
//  angles[5]: angle_ef_target (yaw)    in centi-degree
//  angles[6]: roll change rate         in centi-degrees/second
//  angles[7]: pitch change rate        in centi-degrees/second
//  angles[8]: yaw change rate          in centi-degrees/second
//  angles[9]: angle_ef_error (roll)    in centi-degrees
//  angles[10]: angle_ef_error (pitch)  in centi-degrees
//  angles[11]: angle_ef_error (yaw)    in centi-degrees

//  xy_current.x: current position      in centimeter from home
//  xy_current.y: current position      in centimeter from home
//  xy_current.z: current position      do not used this
//  xy_desired.x: target position       in centimeter from home
//  xy_desired.y: target position       in centimeter from home
//  xy_desired.z: target position       do not used this
//  roll :        current roll          radian
//  pitch:        current pitch         radian  

void inputs_to_outputs(float* z, float* angles,
                       Vector3f xy_current, Vector3f xy_desired,
                       float roll, float pitch)
{
    Vector3f destination = wp_nav.get_wp_destination();
    Vector3f angle_error;
             angle_error.x = angles[0];
             angle_error.y = angles[1];
             angle_error.z = angles[2];
     Vector3f current_angles;
             current_angles.x = roll;
             current_angles.y = pitch;
             current_angles.z = ahrs.yaw;
     Vector3f change_rate;
             change_rate.x = angles[6];
             change_rate.y = angles[7];
             change_rate.z = angles[8];   
     Vector3f desired_angles;
             desired_angles.x = angles[0];
             desired_angles.y = angles[1];
             desired_angles.z = angles[5]; 
   
    if (using_controller != Original_PID_Controller)
    {
        
        GAREAL *rad_per_second;
        //Integrate the calculation for new controllers here
        switch (using_controller)
        {
            case Original_PID_Controller:
                break;
            
            case New_PID_Controller:
            {
                //Inputs: z_error; roll_error; pitch_error; yaw_error
                //Outputs: angular speed of each motors
                //gcs_send_text_fmt(PSTR("r: %f p: %f y: %f \n"),input1,input2,input3);
                //gcs_send_text_fmt(PSTR("p1:%f p2:%f p3:%f\n"),angles[1], angles[4], angles[10]);
                //gcs_send_text_fmt(PSTR("z: %f\n"),z_error);
                rad_per_second = PID_calculate(z[2], angle_error, ahrs.roll, ahrs.pitch);
                
                break;
             }   
             
            case Simple_IB_Controller:
            {
                //Inputs:current_z, desired_z, current_angles, angular_speed, desired_angles
                //Outputs: angular speed of each motors
                //gcs_send_text_fmt(PSTR("y: %f yd: %f  \n"),angle_current.z, desired_angles.z);
                rad_per_second = IB_calculate(z[0], z[1], current_angles, change_rate, desired_angles);
                //gcs_send_text_fmt(PSTR("r1: %f r2: %f r3: %f r4: %f  \n"),rad_per_second[0], rad_per_second[1], rad_per_second[2], rad_per_second[3] );
                break;
            }
                                       
        }
        motors_output(rad_per_second);
    }
    else return; 
    
    
}


/// motors_output - send output to motors library which will adjust and send to ESCs and servos
void motors_output(GAREAL *output_value)
{
    // Limits for our quadrotor
    float b = 0.00012; //Ns2
    float d = 0.000003; //Nms2
    float l = 0.225; //m
    float Torque = output_value[0];    

    io_motors.U1 = output_value[0];
    io_motors.U2 = output_value[1];
    io_motors.U3 = output_value[2];
    io_motors.U4 = output_value[3];
        
    //gcs_send_text_fmt(PSTR("U1:%f U2:%f U3:%f U4:%f \n"),io_motors.U1, io_motors.U2, io_motors.U3, io_motors.U4 );
        
    MotorSpeed_compute(&io_motors);
    
    ///Developing + frame
    if (using_controller == New_PID_Controller)
    {        
        Rotate_speed[3] = io_motors.omgs2[0];
        Rotate_speed[0] = io_motors.omgs2[1];
        Rotate_speed[2] = io_motors.omgs2[2];
        Rotate_speed[1] = io_motors.omgs2[3]; 
     }
     if ((using_controller == Simple_IB_Controller))
     {     
        Rotate_speed[0] =(double) sqrt(abs(Torque/(4.0*b)-output_value[1]/(2.0*b*l)+output_value[3]/(4.0*d)));
        Rotate_speed[1] =(double) sqrt(abs(Torque/(4.0*b)+output_value[1]/(2.0*b*l)+output_value[3]/(4.0*d)));
        Rotate_speed[2] =(double) sqrt(abs(Torque/(4.0*b)+output_value[2]/(2.0*b*l)-output_value[3]/(4.0*d)));
        Rotate_speed[3] =(double) sqrt(abs(Torque/(4.0*b)-output_value[2]/(2.0*b*l)-output_value[3]/(4.0*d)));
      }  
    
    
    for (uint8_t i = 0; i<4; i++)
    {
        if (Rotate_speed[i]<=0.0)
            Rotate_speed[i] = 0 ;
        if (Rotate_speed[i]>216.0)
            Rotate_speed[i] = 216.0;        
    }
  
  //gcs_send_text_fmt(PSTR("r1: %f r2: %f r3: %f r4: %f  \n"),output_value[0], output_value[1], output_value[2], output_value[3] );
    
  motors.output_signal(Rotate_speed);
   
}   