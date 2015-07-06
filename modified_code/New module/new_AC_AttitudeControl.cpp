///////////////////////////////////////////////////////////NEW CODE///////////////////////////////////////////////////////////
void AC_AttitudeControl::new_angle_ef_roll_pitch_yaw(float roll_angle_ef, float pitch_angle_ef, float yaw_angle_ef, bool slew_yaw)
{
    Vector3f    angle_ef_error;

    // set earth-frame angle targets
    _angle_ef_target.x = constrain_float(roll_angle_ef, -_aparm.angle_max, _aparm.angle_max);
    _angle_ef_target.y = constrain_float(pitch_angle_ef, -_aparm.angle_max, _aparm.angle_max);
    _angle_ef_target.z = yaw_angle_ef;

    // calculate earth frame errors
    angle_ef_error.x = wrap_180_cd_float(_angle_ef_target.x - _ahrs.roll_sensor);
    angle_ef_error.y = wrap_180_cd_float(_angle_ef_target.y - _ahrs.pitch_sensor);
    angle_ef_error.z = wrap_180_cd_float(_angle_ef_target.z - _ahrs.yaw_sensor);

    // constrain the yaw angle error
    if (slew_yaw) {
        angle_ef_error.z = constrain_float(angle_ef_error.z,-_slew_yaw,_slew_yaw);
    }

    // convert earth-frame angle errors to body-frame angle errors
    frame_conversion_ef_to_bf(angle_ef_error, _angle_bf_error);

    // convert body-frame angle errors to body-frame rate targets
    update_rate_bf_targets();

    // body-frame to motor outputs should be called separately
    angle_values[0] = _angle_bf_error.x;
    angle_values[1] = _angle_bf_error.y;
    angle_values[2] = _angle_bf_error.z;
    angle_values[3] = _angle_ef_target.x;
    angle_values[4] = _angle_ef_target.y;
    angle_values[5] = _angle_ef_target.z;
    angle_values[6] = _ahrs.get_gyro().x*AC_ATTITUDE_CONTROL_DEGX100;
    angle_values[7] = _ahrs.get_gyro().y*AC_ATTITUDE_CONTROL_DEGX100;
    angle_values[8] = _ahrs.get_gyro().z*AC_ATTITUDE_CONTROL_DEGX100;
    angle_values[9] = angle_ef_error.x;
    angle_values[10] = angle_ef_error.y;
    angle_values[11] = angle_ef_error.z;
    
    //return angle_values;

}

void AC_AttitudeControl::new_angle_ef_roll_pitch_rate_ef_yaw(float roll_angle_ef, float pitch_angle_ef, float yaw_rate_ef)
{
    Vector3f    angle_ef_error;         // earth frame angle errors

    // set earth-frame angle targets for roll and pitch and calculate angle error
    _angle_ef_target.x = constrain_float(roll_angle_ef, -_aparm.angle_max, _aparm.angle_max);
    angle_ef_error.x = wrap_180_cd_float(_angle_ef_target.x - _ahrs.roll_sensor);

    _angle_ef_target.y = constrain_float(pitch_angle_ef, -_aparm.angle_max, _aparm.angle_max);
    angle_ef_error.y = wrap_180_cd_float(_angle_ef_target.y - _ahrs.pitch_sensor);

    if (_accel_y_max > 0.0f) {
        // set earth-frame feed forward rate for yaw
        float rate_change_limit = _accel_y_max * _dt;

        float rate_change = yaw_rate_ef - _rate_ef_desired.z;
        rate_change = constrain_float(rate_change, -rate_change_limit, rate_change_limit);
        _rate_ef_desired.z += rate_change;
        // calculate yaw target angle and angle error
        update_ef_yaw_angle_and_error(_rate_ef_desired.z, angle_ef_error, AC_ATTITUDE_RATE_STAB_YAW_OVERSHOOT_ANGLE_MAX);
    } else {
        // set yaw feed forward to zero
        _rate_ef_desired.z = yaw_rate_ef;
        // calculate yaw target angle and angle error
        update_ef_yaw_angle_and_error(_rate_ef_desired.z, angle_ef_error, AC_ATTITUDE_RATE_STAB_YAW_OVERSHOOT_ANGLE_MAX);
    }

    // convert earth-frame angle errors to body-frame angle errors
    frame_conversion_ef_to_bf(angle_ef_error, _angle_bf_error);

    // convert body-frame angle errors to body-frame rate targets
    update_rate_bf_targets();

    // set roll and pitch feed forward to zero
    _rate_ef_desired.x = 0;
    _rate_ef_desired.y = 0;
    // convert earth-frame feed forward rates to body-frame feed forward rates
    frame_conversion_ef_to_bf(_rate_ef_desired, _rate_bf_desired);
    _rate_bf_target += _rate_bf_desired;
    
    angle_values[0] = {_angle_bf_error.x};
    angle_values[1] = {_angle_bf_error.y};
    angle_values[2] = {_angle_bf_error.z};
    angle_values[3] = {_angle_ef_target.x};
    angle_values[4] = {_angle_ef_target.y};
    angle_values[5] = {_angle_ef_target.z};
    angle_values[6] = (_ahrs.get_gyro().x*AC_ATTITUDE_CONTROL_DEGX100);
    angle_values[7] = (_ahrs.get_gyro().y*AC_ATTITUDE_CONTROL_DEGX100);
    angle_values[8] = (_ahrs.get_gyro().z*AC_ATTITUDE_CONTROL_DEGX100);
    angle_values[9] = angle_ef_error.x;
    angle_values[10] = angle_ef_error.y;
    angle_values[11] = angle_ef_error.z;

    
}

void AC_AttitudeControl::new_angle_ef_roll_pitch_rate_ef_yaw_smooth(float roll_angle_ef, float pitch_angle_ef, float yaw_rate_ef, float smoothing_gain)
{
    Vector3f angle_ef_error;    // earth frame angle errors

    // sanity check smoothing gain
    smoothing_gain = constrain_float(smoothing_gain,1.0f,50.0f);

    if (_accel_rp_max > 0.0f) {
        float rate_ef_desired;
        float rate_change_limit = _accel_rp_max * _dt;

        // calculate earth-frame feed forward roll rate using linear response when close to the target, sqrt response when we're further away
        rate_ef_desired = sqrt_controller(roll_angle_ef-_angle_ef_target.x, smoothing_gain, _accel_rp_max);

        // apply acceleration limit to feed forward roll rate
        _rate_ef_desired.x = constrain_float(rate_ef_desired, _rate_ef_desired.x-rate_change_limit, _rate_ef_desired.x+rate_change_limit);

        // update earth-frame roll angle target using desired roll rate
        update_ef_roll_angle_and_error(_rate_ef_desired.x, angle_ef_error, AC_ATTITUDE_RATE_STAB_ROLL_OVERSHOOT_ANGLE_MAX);

        // calculate earth-frame feed forward pitch rate using linear response when close to the target, sqrt response when we're further away
        rate_ef_desired = sqrt_controller(pitch_angle_ef-_angle_ef_target.y, smoothing_gain, _accel_rp_max);

        // apply acceleration limit to feed forward pitch rate
        _rate_ef_desired.y = constrain_float(rate_ef_desired, _rate_ef_desired.y-rate_change_limit, _rate_ef_desired.y+rate_change_limit);

        // update earth-frame pitch angle target using desired pitch rate
        update_ef_pitch_angle_and_error(_rate_ef_desired.y, angle_ef_error, AC_ATTITUDE_RATE_STAB_PITCH_OVERSHOOT_ANGLE_MAX);
    } else {
        // target roll and pitch to desired input roll and pitch
        _angle_ef_target.x = roll_angle_ef;
        angle_ef_error.x = wrap_180_cd_float(_angle_ef_target.x - _ahrs.roll_sensor);

        _angle_ef_target.y = pitch_angle_ef;
        angle_ef_error.y = wrap_180_cd_float(_angle_ef_target.y - _ahrs.pitch_sensor);

        // set roll and pitch feed forward to zero
        _rate_ef_desired.x = 0;
        _rate_ef_desired.y = 0;
    }
    // constrain earth-frame angle targets
    _angle_ef_target.x = constrain_float(_angle_ef_target.x, -_aparm.angle_max, _aparm.angle_max);
    _angle_ef_target.y = constrain_float(_angle_ef_target.y, -_aparm.angle_max, _aparm.angle_max);

    if (_accel_y_max > 0.0f) {
        // set earth-frame feed forward rate for yaw
        float rate_change_limit = _accel_y_max * _dt;

        // update yaw rate target with accele
        _rate_ef_desired.z += constrain_float(yaw_rate_ef - _rate_ef_desired.z, -rate_change_limit, rate_change_limit);

        // calculate yaw target angle and angle error
        update_ef_yaw_angle_and_error(_rate_ef_desired.z, angle_ef_error, AC_ATTITUDE_RATE_STAB_YAW_OVERSHOOT_ANGLE_MAX);
    } else {
        // set yaw feed forward to zero
        _rate_ef_desired.z = yaw_rate_ef;
        // calculate yaw target angle and angle error
        update_ef_yaw_angle_and_error(_rate_ef_desired.z, angle_ef_error, AC_ATTITUDE_RATE_STAB_YAW_OVERSHOOT_ANGLE_MAX);
    }

    // convert earth-frame angle errors to body-frame angle errors
    frame_conversion_ef_to_bf(angle_ef_error, _angle_bf_error);


    // convert body-frame angle errors to body-frame rate targets
    update_rate_bf_targets();

    // add body frame rate feed forward
    if (_rate_bf_ff_enabled) {
        // convert earth-frame feed forward rates to body-frame feed forward rates
        frame_conversion_ef_to_bf(_rate_ef_desired, _rate_bf_desired);
        _rate_bf_target += _rate_bf_desired;
    } else {
        // convert earth-frame feed forward rates to body-frame feed forward rates
        frame_conversion_ef_to_bf(Vector3f(0,0,_rate_ef_desired.z), _rate_bf_desired);
        _rate_bf_target += _rate_bf_desired;
    }

    angle_values[0] = {_angle_bf_error.x};
    angle_values[1] = {_angle_bf_error.y};
    angle_values[2] = {_angle_bf_error.z};
    angle_values[3] = {_angle_ef_target.x};
    angle_values[4] = {_angle_ef_target.y};
    angle_values[5] = {_angle_ef_target.z};
    angle_values[6] = (_ahrs.get_gyro().x*AC_ATTITUDE_CONTROL_DEGX100);
    angle_values[7] = (_ahrs.get_gyro().y*AC_ATTITUDE_CONTROL_DEGX100);
    angle_values[8] = (_ahrs.get_gyro().z*AC_ATTITUDE_CONTROL_DEGX100);
    angle_values[9] = angle_ef_error.x;
    angle_values[10] = angle_ef_error.y;
    angle_values[11] = angle_ef_error.z;
}