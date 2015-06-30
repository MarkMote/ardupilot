/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
/*
 * control_multi_controller.pde
 *
 * This file contains the implementation for Land, Waypoint navigation and Takeoff from Auto mode using a virtual controller 
 * Command execution code (i.e. command_logic.pde) should:
 *      a) switch to Auto flight mode with set_mode() function.  This will cause auto_init to be called
 *      b) call one of the three auto initialisation functions: auto_wp_start(), auto_takeoff_start(), auto_land_start()
 *      c) call one of the verify functions auto_wp_verify(), auto_takeoff_verify, auto_land_verify repeated to check if the command has completed
 * The main loop (i.e. fast loop) will call update_flight_modes() which will in turn call auto_run() which, based upon the auto_mode variable will call
 *      correct auto_wp_run, auto_takeoff_run or auto_land_run to actually implement the feature
 */

/*
 *  While in the auto flight mode, navigation or do/now commands can be run.
 *  Code in this file implements the navigation commands
 */
 
 /*
  * Code in this file is based on the original ArduPilot from the following file:
  *     1/control_auto.pde
  *     2/control_land.pde
  * Last modified 21/5/2015 by Quang Nguyen
  */

///Variables
float* z_outputs;
float* angle_outputs;
Vector3f xy_desired;
Vector3f xy_current;
///////////////////////////////////////////////////AUTO MODE////////////////////////////////////////////////////////
// auto_run_multi - runs the auto controller
//      should be called at 100hz or more
//      relies on run_autopilot being called at 10hz which handles decision making and non-navigation related commands
static void new_auto_run()
{
    // call the correct auto controller
    switch (auto_mode) {

    case Auto_TakeOff:
        new_auto_takeoff();
        break;

    case Auto_WP:
    case Auto_CircleMoveToEdge:
        new_auto_wp();
        break;

    case Auto_Land:
        
        new_auto_land();
        break;

    case Auto_RTL:
        new_rtl_run();
        break;

    case Auto_Circle:
        new_auto_circle_run();
        break;

    case Auto_Spline:
        new_auto_spline();
        break;

    case Auto_NavGuided:
#if NAV_GUIDED == ENABLED
        //auto_nav_guided_run();
        //new_auto_nav_guided();
#endif
        break;

    case Auto_Loiter:
        //auto_loiter_run();
        new_auto_loiter();
        break;
    }
}

static void new_auto_takeoff()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        // initialise wpnav targets
        wp_nav.shift_wp_origin_to_current_pos();
        // reset attitude control targets
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // tell motors to do a slow start
        motors.slow_start(true);
        return;
    }

    // process pilot's yaw input
    float target_yaw_rate = 0;
    /*if (!failsafe.radio) {
        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
    }*/

    // run waypoint controller
    wp_nav.update_wpnav();
    
    // Get the desired x,y position in earth-frame
    pos_control.get_stopping_point_xy(xy_desired);
    
     // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();

    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
    //Get angle values (error in Roll, Pitch, Yaw, target Roll, Pitch, Yaw)
    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
    angle_outputs = attitude_control.angle_values;

    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
}

// auto_wp_run - runs the auto waypoint controller
//      called by auto_run at 100hz or more
static void new_auto_wp()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        // To-Do: reset waypoint origin to current location because copter is probably on the ground so we don't want it lurching left or right on take-off
        //    (of course it would be better if people just used take-off)
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // tell motors to do a slow start
        motors.slow_start(true);
        return;
    }

    /*// process pilot's yaw input
    float target_yaw_rate = 0;
    if (!failsafe.radio) {
        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
        if (target_yaw_rate != 0) {
            set_auto_yaw_mode(AUTO_YAW_HOLD);
        }
    }*/
    
    
    // run waypoint controller
    wp_nav.update_wpnav();
    
    // Get the desired x,y position in earth-frame. 
    // Therefore xy_desired.x = x_desired; xy_desired.y = y_desired; Do not use xy_desired.z, use z_values[1] instead
    pos_control.get_stopping_point_xy(xy_desired);
    
    // call z-axis position controller (wpnav should have already updated it's alt target)
    //z_values includes current_z, desired_z, pos_error_z respectively
       
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();
    
    // This function will get the error of roll, pitch, yaw in bf respectively
    attitude_control.new_angle_ef_roll_pitch_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), get_auto_heading(),true);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
}

static void new_auto_land()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed || ap.land_complete) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // set target to current position
        wp_nav.init_loiter_target();
        return;
    }    
    
    int16_t roll_control = 0, pitch_control = 0;
    float target_yaw_rate = 0;

    // if not auto armed set throttle to zero and exit immediately
   // relax loiter targets if we might be landed
    if (land_complete_maybe()) {
        wp_nav.loiter_soften_for_landing();
    }

    // process roll, pitch inputs
    wp_nav.set_pilot_desired_acceleration(roll_control, pitch_control);

    // run loiter controller
    wp_nav.update_loiter(ekfGndSpdLimit, ekfNavVelGainScaler);

    // call z-axis position controller
    float cmb_rate = get_land_descent_speed();
    pos_control.set_alt_target_from_climb_rate(cmb_rate, G_Dt, true);
      
    // record desired climb rate for logging
    desired_climb_rate = cmb_rate;
    
     // Get the desired x,y position in earth-frame. 
    // Therefore xy_desired.x = x_desired; xy_desired.y = y_desired; Do not use xy_desired.z, use z_values[1] instead
    pos_control.get_stopping_point_xy(xy_desired);
    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();

    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
    //Get angle values (error in Roll, Pitch, Yaw, target Roll, Pitch, Yaw)
    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);

}

// auto_spline_run - runs the auto spline controller
//      called by auto_run at 100hz or more
static void new_auto_spline()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        // To-Do: reset waypoint origin to current location because copter is probably on the ground so we don't want it lurching left or right on take-off
        //    (of course it would be better if people just used take-off)
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // tell motors to do a slow start
        motors.slow_start(true);
        return;
    }

    // process pilot's yaw input
    float target_yaw_rate = 0;
    /*if (!failsafe.radio) {
        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
        if (target_yaw_rate != 0) {
            set_auto_yaw_mode(AUTO_YAW_HOLD);
        }
    }*/

    // run waypoint controller
    wp_nav.update_spline();

    // Get the desired x,y position in earth-frame. 
    // Therefore xy_desired.x = x_desired; xy_desired.y = y_desired; Do not use xy_desired.z, use z_values[1] instead
    pos_control.get_stopping_point_xy(xy_desired);
    
    // call z-axis position controller (wpnav should have already updated it's alt target)
    //z_values includes current_z, desired_z, pos_error_z respectively
       
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();
    
    // This function will get the error of roll, pitch, yaw in bf respectively
    attitude_control.new_angle_ef_roll_pitch_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), get_auto_heading(),true);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
}

void new_auto_circle_run()
{
    // call circle controller
    circle_nav.update();

    // call z-axis position controller
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values; 

    
    pos_control.get_stopping_point_xy(xy_desired);  

    xy_current = pos_control.xy_current();

    // roll & pitch from waypoint controller, yaw rate from pilot
    attitude_control.new_angle_ef_roll_pitch_yaw(circle_nav.get_roll(), circle_nav.get_pitch(), circle_nav.get_yaw(),true);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
}

void new_auto_loiter()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed || ap.land_complete) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        return;
    }

    // accept pilot input of yaw
    float target_yaw_rate = 0;
    /*if(!failsafe.radio) {
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
    }*/

    // run waypoint and z-axis postion controller
    wp_nav.update_wpnav();
    // Get the desired x,y position in earth-frame
    pos_control.get_stopping_point_xy(xy_desired);
    
     // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();

    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
    //Get angle values (error in Roll, Pitch, Yaw, target Roll, Pitch, Yaw)
    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
    angle_outputs = attitude_control.angle_values;

    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
    
   
}

//////////////////////////////////////////////////////////////////LAND MODE/////////////////////////////////////////////////////////////////
static void new_land_run()
{
    if (land_with_gps) {
        new_land_gps_run();
    }else{
        new_land_nogps();
    }

}

static void new_land_gps_run()
{
    int16_t roll_control = 0, pitch_control = 0;
    float target_yaw_rate = 0;
    
    // relax loiter target if we might be landed
    if (land_complete_maybe()) {
        wp_nav.loiter_soften_for_landing();
    }

    // process roll, pitch inputs
    wp_nav.set_pilot_desired_acceleration(roll_control, pitch_control);

    // run loiter controller
    wp_nav.update_loiter(ekfGndSpdLimit, ekfNavVelGainScaler);

    //Get angle values (error in Roll, Pitch, Yaw, target Roll, Pitch, Yaw)
    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
    angle_outputs = attitude_control.angle_values;

    // pause 4 seconds before beginning land descent
    float cmb_rate;
    if(land_pause && millis()-land_start_time < 4000) {
        cmb_rate = 0;
    } else {
        land_pause = false;
        cmb_rate = get_land_descent_speed();
    }

    // record desired climb rate for logging
    desired_climb_rate = cmb_rate;

    // update altitude target and call position controller
    pos_control.set_alt_target_from_climb_rate(cmb_rate, G_Dt, true);
    
    
    pos_control.get_stopping_point_xy(xy_desired);
    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();

    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
       
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
     
}

static void new_land_nogps()
{
    int16_t target_roll = 0, target_pitch = 0;
    float target_yaw_rate = 0;

    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(target_roll, target_pitch, target_yaw_rate);
    angle_outputs = attitude_control.angle_values;
    // pause 4 seconds before beginning land descent
    float cmb_rate;
    if(land_pause && millis()-land_start_time < LAND_WITH_DELAY_MS) {
        cmb_rate = 0;
    } else {
        land_pause = false;
        cmb_rate = get_land_descent_speed();
    }

    // record desired climb rate for logging
    desired_climb_rate = cmb_rate;

    // call position controller
    pos_control.set_alt_target_from_climb_rate(cmb_rate, G_Dt, true);
    
    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
    
    pos_control.get_stopping_point_xy(xy_desired);
    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
}

/////////////////////////////////////////////////RETURN TO LAUNCH MODE/////////////////////////////////////////////////////////
static void new_rtl_run()
{
    // check if we need to move to next state
    if (rtl_state_complete) {
        switch (rtl_state) {
        case InitialClimb:
            rtl_return_start();
            break;
        case ReturnHome:
            rtl_loiterathome_start();
            break;
        case LoiterAtHome:
            if (g.rtl_alt_final > 0 && !failsafe.radio) {
                rtl_descent_start();
            }else{
                rtl_land_start();
            }
            break;
        case FinalDescent:
            // do nothing
            break;
        case Land:
            // do nothing - rtl_land_run will take care of disarming motors
            break;
        }
    }

    // call the correct run function
    switch (rtl_state) {

    case InitialClimb:
        new_rtl_climb_return_run();
        break;

    case ReturnHome:
        new_rtl_climb_return_run();
        break;

    case LoiterAtHome:
        new_rtl_loiterathome_run();
        break;

    case FinalDescent:
        new_rtl_descent_run();
        break;

    case Land:
        new_rtl_land_run();
        break;
    }
}


// rtl_climb_return_run - implements the initial climb, return home and descent portions of RTL which all rely on the wp controller
//      called by rtl_run at 100hz or more
static void new_rtl_climb_return_run()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        // reset attitude control targets
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // To-Do: re-initialise wpnav targets
        return;
    }

    // process pilot's yaw input
    float target_yaw_rate = 0;
    if (!failsafe.radio) {
        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
        if (target_yaw_rate != 0) {
            set_auto_yaw_mode(AUTO_YAW_HOLD);
        }
    }

    // run waypoint controller
    wp_nav.update_wpnav();

     // Get the desired x,y position in earth-frame. 
    // Therefore xy_desired.x = x_desired; xy_desired.y = y_desired; Do not use xy_desired.z, use z_values[1] instead
    
    pos_control.get_stopping_point_xy(xy_desired);
    
    // call z-axis position controller (wpnav should have already updated it's alt target)
    //z_values includes current_z, desired_z, pos_error_z respectively
       
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();
    
    // This function will get the error of roll, pitch, yaw in bf respectively
    attitude_control.new_angle_ef_roll_pitch_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), get_auto_heading(),true);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
    // check if we've completed this stage of RTL
    rtl_state_complete = wp_nav.reached_wp_destination();
    
}

// rtl_climb_return_descent_run - implements the initial climb, return home and descent portions of RTL which all rely on the wp controller
//      called by rtl_run at 100hz or more
static void new_rtl_loiterathome_run()
{
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        // reset attitude control targets
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // To-Do: re-initialise wpnav targets
        return;
    }

    // process pilot's yaw input
    float target_yaw_rate = 0;
    if (!failsafe.radio) {
        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
        if (target_yaw_rate != 0) {
            set_auto_yaw_mode(AUTO_YAW_HOLD);
        }
    }

    // run waypoint controller
    wp_nav.update_wpnav();

    // Therefore xy_desired.x = x_desired; xy_desired.y = y_desired; Do not use xy_desired.z, use z_values[1] instead
    
    pos_control.get_stopping_point_xy(xy_desired);
    
    // call z-axis position controller (wpnav should have already updated it's alt target)
    //z_values includes current_z, desired_z, pos_error_z respectively
       
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;    
    // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();
    
    // This function will get the error of roll, pitch, yaw in bf respectively
    attitude_control.new_angle_ef_roll_pitch_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), get_auto_heading(),true);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
    
    if ((millis() - rtl_loiter_start_time) >= (uint32_t)g.rtl_loiter_time.get()) {
        if (auto_yaw_mode == AUTO_YAW_RESETTOARMEDYAW) {
            // check if heading is within 2 degrees of heading when vehicle was armed
            if (labs(wrap_180_cd(ahrs.yaw_sensor-initial_armed_bearing)) <= 200) {
                rtl_state_complete = true;
            }
        } else {
            // we have loitered long enough
            rtl_state_complete = true;
        }
    }
}

// rtl_descent_run - implements the final descent to the RTL_ALT
//      called by rtl_run at 100hz or more
static void new_rtl_descent_run()
{
    int16_t roll_control = 0, pitch_control = 0;
    float target_yaw_rate = 0;

    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // set target to current position
        wp_nav.init_loiter_target();
        return;
    }

    // process pilot's input
    if (!failsafe.radio) {
        if (g.land_repositioning) {
            // apply SIMPLE mode transform to pilot inputs
            update_simple_mode();

            // process pilot's roll and pitch input
            roll_control = g.rc_1.control_in;
            pitch_control = g.rc_2.control_in;
        }

        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
    }

    // process roll, pitch inputs
    wp_nav.set_pilot_desired_acceleration(roll_control, pitch_control);

    // run loiter controller
    wp_nav.update_loiter(ekfGndSpdLimit, ekfNavVelGainScaler);

    // call z-axis position controller
    pos_control.set_alt_target_with_slew(pv_alt_above_origin(g.rtl_alt_final), G_Dt);
    
    // Get the desired x,y position in earth-frame
    
    pos_control.get_stopping_point_xy(xy_desired);
    
     // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();

    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
    //Get angle values (error in Roll, Pitch, Yaw, target Roll, Pitch, Yaw)
    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
    // check if we've reached within 20cm of final altitude
    rtl_state_complete = fabs(g.rtl_alt_final - inertial_nav.get_altitude()) < 20.0f;
}

// rtl_returnhome_run - return home
//      called by rtl_run at 100hz or more
static void new_rtl_land_run()
{
    int16_t roll_control = 0, pitch_control = 0;
    float target_yaw_rate = 0;
    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed || ap.land_complete) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        // set target to current position
        wp_nav.init_loiter_target();

#if LAND_REQUIRE_MIN_THROTTLE_TO_DISARM == ENABLED
        // disarm when the landing detector says we've landed and throttle is at minimum
        if (ap.land_complete && (ap.throttle_zero || failsafe.radio)) {
            init_disarm_motors();
        }
#else
        // disarm when the landing detector says we've landed
        if (ap.land_complete) {
            init_disarm_motors();
        }
#endif

        // check if we've completed this stage of RTL
        rtl_state_complete = ap.land_complete;
        return;
    }

    // relax loiter target if we might be landed
    if (land_complete_maybe()) {
        wp_nav.loiter_soften_for_landing();
    }

    // process pilot's input
    if (!failsafe.radio) {
        if (g.land_repositioning) {
            // apply SIMPLE mode transform to pilot inputs
            update_simple_mode();

            // process pilot's roll and pitch input
            roll_control = g.rc_1.control_in;
            pitch_control = g.rc_2.control_in;
        }

        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
    }

     // process pilot's roll and pitch input
    wp_nav.set_pilot_desired_acceleration(roll_control, pitch_control);

    // run loiter controller
    wp_nav.update_loiter(ekfGndSpdLimit, ekfNavVelGainScaler);

    // call z-axis position controller
    float cmb_rate = get_land_descent_speed();
    pos_control.set_alt_target_from_climb_rate(cmb_rate, G_Dt, true);
   
    // Get the desired x,y position in earth-frame
    
    pos_control.get_stopping_point_xy(xy_desired);
    
     // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();

    //Get altitude values (current, desire, error)
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
    // record desired climb rate for logging
    desired_climb_rate = cmb_rate;
    
    //Get angle values (error in Roll, Pitch, Yaw, target Roll, Pitch, Yaw)
    attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
    angle_outputs = attitude_control.angle_values;
    
    ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
    // check if we've completed this stage of RTL
    rtl_state_complete = ap.land_complete;
}

///////////////////////////////////////////////////////ALTITUDE HOLD//////////////////////////////////////////////////////////
// althold_run - runs the althold controller
// should be called at 100hz or more
static void new_althold_run()
{
    int16_t target_roll, target_pitch;
    float target_yaw_rate;
    int16_t target_climb_rate;

    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        pos_control.set_alt_target_to_current_alt();
        return;
    }

    // apply SIMPLE mode transform to pilot inputs
    update_simple_mode();

    // get pilot desired lean angles
    // To-Do: convert get_pilot_desired_lean_angles to return angles as floats
    get_pilot_desired_lean_angles(g.rc_1.control_in, g.rc_2.control_in, target_roll, target_pitch);

    // get pilot's desired yaw rate
    target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);

    // get pilot desired climb rate
    target_climb_rate = get_pilot_desired_climb_rate(g.rc_3.control_in);

    // check for pilot requested take-off
    if (ap.land_complete && target_climb_rate > 0) {
        // indicate we are taking off
        set_land_complete(false);
        // clear i term when we're taking off
        set_throttle_takeoff();
    }

    // reset target lean angles and heading while landed
    if (ap.land_complete) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        // move throttle to between minimum and non-takeoff-throttle to keep us on the ground
        attitude_control.set_throttle_out(get_throttle_pre_takeoff(g.rc_3.control_in), false);
        pos_control.set_alt_target_to_current_alt();
    }else{
        // call attitude controller
        attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw_smooth(target_roll, target_pitch, target_yaw_rate, get_smoothing_gain());
        angle_outputs = attitude_control.angle_values;
    
        // call throttle controller
        if (sonar_alt_health >= SONAR_ALT_HEALTH_MAX) {
            // if sonar is ok, use surface tracking
            target_climb_rate = get_throttle_surface_tracking(target_climb_rate, pos_control.get_alt_target(), G_Dt);
        }

        // call throttle controller
        if (sonar_alt_health >= SONAR_ALT_HEALTH_MAX) {
            // if sonar is ok, use surface tracking
            target_climb_rate = get_throttle_surface_tracking(target_climb_rate, pos_control.get_alt_target(), G_Dt);
        }

        // call position controller
        pos_control.set_alt_target_from_climb_rate(target_climb_rate, G_Dt);
        pos_control.update_z_controller_new();
        z_outputs = pos_control.z_values;
        
         // Get the desired x,y position in earth-frame
        
        pos_control.get_stopping_point_xy(xy_desired);
    
        // This function will get the current position in x,y respectively
        xy_current = pos_control.xy_current();
        
        ///Send values to the general handling code
        inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
        // body-frame rate controller is run directly from 100hz loop
        
    }
}

//////////////////////////////////////////////////LOITER MODE///////////////////////////////////////////////////////
static void new_loiter_run()
{
    float target_yaw_rate = 0;
    float target_climb_rate = 0;

    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed) {
        wp_nav.init_loiter_target();
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        pos_control.set_alt_target_to_current_alt();
        return;
    }

    // process pilot inputs
    if (!failsafe.radio) {
        // apply SIMPLE mode transform to pilot inputs
        update_simple_mode();

        // process pilot's roll and pitch input
        wp_nav.set_pilot_desired_acceleration(g.rc_1.control_in, g.rc_2.control_in);

        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);

        // get pilot desired climb rate
        target_climb_rate = get_pilot_desired_climb_rate(g.rc_3.control_in);

        // check for pilot requested take-off
        if (ap.land_complete && target_climb_rate > 0) {
            // indicate we are taking off
            set_land_complete(false);
            // clear i term when we're taking off
            set_throttle_takeoff();
        }
    } else {
        // clear out pilot desired acceleration in case radio failsafe event occurs and we do not switch to RTL for some reason
        wp_nav.clear_pilot_desired_acceleration();
    }

    // relax loiter target if we might be landed
    if (land_complete_maybe()) {
        wp_nav.loiter_soften_for_landing();
    }

    // when landed reset targets and output zero throttle
    if (ap.land_complete) {
        wp_nav.init_loiter_target();
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        // move throttle to between minimum and non-takeoff-throttle to keep us on the ground
        attitude_control.set_throttle_out(get_throttle_pre_takeoff(g.rc_3.control_in), false);
        pos_control.set_alt_target_to_current_alt();
    }else{
        // run loiter controller
        wp_nav.update_loiter(ekfGndSpdLimit, ekfNavVelGainScaler);

        // call attitude controller
        attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(wp_nav.get_roll(), wp_nav.get_pitch(), target_yaw_rate);
        angle_outputs = attitude_control.angle_values;
        

        // run altitude controller
        if (sonar_alt_health >= SONAR_ALT_HEALTH_MAX) {
            // if sonar is ok, use surface tracking
            target_climb_rate = get_throttle_surface_tracking(target_climb_rate, pos_control.get_alt_target(), G_Dt);
        }

        // update altitude target and call position controller
        pos_control.set_alt_target_from_climb_rate(target_climb_rate, G_Dt);
        pos_control.update_z_controller_new();
        z_outputs = pos_control.z_values;
        
         // Get the desired x,y position in earth-frame
        
        pos_control.get_stopping_point_xy(xy_desired);
    
        // This function will get the current position in x,y respectively
        xy_current = pos_control.xy_current();
        
        ///Send values to the general handling code
        inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
        // body-frame rate controller is run directly from 100hz loop
    }
}

/////////////////////////////////////////////////////////////////POSHOLD MODE///////////////////////////////////////////////////////
///Because of the specialties of this flight mode, it must be put in the original control_poshold.pde
///The new method is called new_poshold_run and it can be found at the end of the original file

///////////////////////////////////////////////////////////////CIRCLE MODE///////////////////////////////////////////////////////
static void new_circle_run()
{
    float target_yaw_rate = 0;
    float target_climb_rate = 0;

    // if not auto armed set throttle to zero and exit immediately
    if(!ap.auto_armed || ap.land_complete) {
        // To-Do: add some initialisation of position controllers
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        pos_control.set_alt_target_to_current_alt();
        return;
    }

    // process pilot inputs
    if (!failsafe.radio) {
        // get pilot's desired yaw rate
        target_yaw_rate = get_pilot_desired_yaw_rate(g.rc_4.control_in);
        if (target_yaw_rate != 0) {
            circle_pilot_yaw_override = true;
        }

        // get pilot desired climb rate
        target_climb_rate = get_pilot_desired_climb_rate(g.rc_3.control_in);

        // check for pilot requested take-off
        if (ap.land_complete && target_climb_rate > 0) {
            // indicate we are taking off
            set_land_complete(false);
            // clear i term when we're taking off
            set_throttle_takeoff();
        }
    }

    // run circle controller
    circle_nav.update();

    // call attitude controller
    if (circle_pilot_yaw_override) {
        attitude_control.new_angle_ef_roll_pitch_rate_ef_yaw(circle_nav.get_roll(), circle_nav.get_pitch(), target_yaw_rate);
    }else{
        attitude_control.new_angle_ef_roll_pitch_yaw(circle_nav.get_roll(), circle_nav.get_pitch(), circle_nav.get_yaw(),true);
    }
    angle_outputs = attitude_control.angle_values;

    // run altitude controller
    if (sonar_alt_health >= SONAR_ALT_HEALTH_MAX) {
        // if sonar is ok, use surface tracking
        target_climb_rate = get_throttle_surface_tracking(target_climb_rate, pos_control.get_alt_target(), G_Dt);
    }
    // update altitude target and call position controller
    pos_control.set_alt_target_from_climb_rate(target_climb_rate, G_Dt);
    pos_control.update_z_controller_new();
    z_outputs = pos_control.z_values;
    
   // Get the desired x,y position in earth-frame
    
    pos_control.get_stopping_point_xy(xy_desired);
   
   // This function will get the current position in x,y respectively
    xy_current = pos_control.xy_current();
        
   ///Send values to the general handling code
    inputs_to_outputs(z_outputs, angle_outputs, xy_current, xy_desired, ahrs.roll, ahrs.pitch);
    
}
