///////////////////////////////////////////////////////////NEW_FUNCTIONS////////////////////////////////////
void AC_PosControl::update_z_controller_new()
{
    // check time since last cast
    uint32_t now = hal.scheduler->millis();
    if (now - _last_update_z_ms > POSCONTROL_ACTIVE_TIMEOUT_MS) {
        _flags.reset_rate_to_accel_z = true;
        _flags.reset_accel_to_throttle = true;
    }
    _last_update_z_ms = now;

    // check if leash lengths need to be recalculated
    calc_leash_length_z();

    // call position controller
    //z_values includes current_z, desired_z, pos_error_z respectively
    pos_to_rate_z_new();
     
    
}

void AC_PosControl::pos_to_rate_z_new()
{
    float curr_alt = _inav.get_altitude();

    // clear position limit flags
    _limit.pos_up = false;
    _limit.pos_down = false;

    // calculate altitude error
    _pos_error.z = _pos_target.z - curr_alt;

    // do not let target altitude get too far from current altitude
    if (_pos_error.z > _leash_up_z) {
        _pos_target.z = curr_alt + _leash_up_z;
        _pos_error.z = _leash_up_z;
        _limit.pos_up = true;
    }
    if (_pos_error.z < -_leash_down_z) {
        _pos_target.z = curr_alt - _leash_down_z;
        _pos_error.z = -_leash_down_z;
        _limit.pos_down = true;
    }

    // calculate _vel_target.z using from _pos_error.z using sqrt controller
    _vel_target.z = AC_AttitudeControl::sqrt_controller(_pos_error.z, _p_alt_pos.kP(), _accel_z_cms);

    // call rate based throttle controller which will update accel based throttle controller targets
    rate_to_accel_z();
        
    z_values[0] = curr_alt;
    z_values[1] = _pos_target.z;
    z_values[2] = _pos_error.z;
    z_values[3] = _pos_target.x;
    z_values[4] = _pos_target.y;
     
}

Vector3f AC_PosControl::xy_current()
{
    const Vector3f& curr_pos = _inav.get_position();
    return curr_pos;
}