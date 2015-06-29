/*
    PIDcontroller.c
    Generated by Gene-Auto toolset ver 2.4.10
    (launcher GALauncher)
    Generated on: 25/02/2015 16:31:51.436
    source model: PIDcontroller
    model version: 6.5
    last saved by:
    last saved on:
*/

/* Includes */

#include "PIDcontroller.h"

/* Variable definitions */

t_PID_z_io _PID_z_io;
t_PID_phi_io _PID_phi_io;
t_PID_theta_io _PID_theta_io;
t_PID_psi_io _PID_psi_io;
GAUINT8 i1;

/* Function definitions */

void PIDcontroller_init(t_PIDcontroller_state *_state_) {
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>  */

    PID_z_init(_state_);
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>  */
    PID_phi_init(_state_);
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>  */
    PID_theta_init(_state_);
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>  */
    PID_psi_init(_state_);
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
    _state_->t_prev_memory = (-0.5);
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
}

void PIDcontroller_compute(t_PIDcontroller_io *_io_, t_PIDcontroller_state *_state_) {
    /*  Output from <SystemBlock: name=PIDcontroller>/<SourceBlock: name=t>/<OutDataPort: name=>  */
    GAREAL t;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SourceBlock: name=e>/<OutDataPort: name=>  */
    GAREAL e[4];
    /*  Output from <SystemBlock: name=PIDcontroller>/<SourceBlock: name=gains>/<OutDataPort: name=>  */
    GAREAL gains[12];
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux>/<OutDataPort: name=>  */
    GAREAL e_z;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux>/<OutDataPort: name=>  */
    GAREAL e_phi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux>/<OutDataPort: name=>  */
    GAREAL e_theta;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux>/<OutDataPort: name=>  */
    GAREAL e_psi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kp_z;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Ki_z;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Demux1;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kp_phi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Ki_phi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kd_phi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kp_theta;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Ki_theta;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kd_theta;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kp_psi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Ki_psi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>/<OutDataPort: name=>  */
    GAREAL Kd_psi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Mux>/<OutDataPort: name=>  */
    GAREAL y[4];
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>/<OutDataPort: name=y>  */
    GAREAL y_phi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>/<OutDataPort: name=y>  */
    GAREAL y_psi;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>/<OutDataPort: name=y>  */
    GAREAL y_theta;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<OutDataPort: name=y>  */
    GAREAL y_z;
    /*  Output from <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=dt>/<OutDataPort: name=>  */
    GAREAL dt;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>/<OutDataPort: name=>  */
    GAREAL t_prev;
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SourceBlock: name=t>  */
    t = _io_->t;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SourceBlock: name=t>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
    t_prev = _state_->t_prev_memory;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=dt>  */
    dt = t - t_prev;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=dt>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SourceBlock: name=e>  */
    for (i1 = 0; i1 < 4; i1++) {
        e[i1] = _io_->e[i1];
    }
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SourceBlock: name=e>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SourceBlock: name=gains>  */
    for (i1 = 0; i1 < 12; i1++) {
        gains[i1] = _io_->gains[i1];
    }
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SourceBlock: name=gains>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux>  */
    e_z = e[0];
    e_phi = e[1];
    e_theta = e[2];
    e_psi = e[3];
    /*  END Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>  */
    Kp_z = gains[0];
    Ki_z = gains[1];
    Demux1 = gains[2];
    Kp_phi = gains[3];
    Ki_phi = gains[4];
    Kd_phi = gains[5];
    Kp_theta = gains[6];
    Ki_theta = gains[7];
    Kd_theta = gains[8];
    Kp_psi = gains[9];
    Ki_psi = gains[10];
    Kd_psi = gains[11];
    /*  END Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Demux1>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>  */
    _PID_z_io.dt = Demux1;
    _PID_z_io.u = Demux1;
    _PID_z_io.Kp = Demux1;
    _PID_z_io.Ki = Demux1;
    _PID_z_io.Kd = Demux1;
    PID_z_compute(&_PID_z_io, _state_);
    y_z = _PID_z_io.y;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>  */
    _PID_phi_io.dt = Demux1;
    _PID_phi_io.u = Demux1;
    _PID_phi_io.Kp = Demux1;
    _PID_phi_io.Ki = Demux1;
    _PID_phi_io.Kd = Demux1;
    PID_phi_compute(&_PID_phi_io, _state_);
    y_phi = _PID_phi_io.y;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>  */
    _PID_theta_io.dt = Demux1;
    _PID_theta_io.u = Demux1;
    _PID_theta_io.Kp = Demux1;
    _PID_theta_io.Ki = Demux1;
    _PID_theta_io.Kd = Demux1;
    PID_theta_compute(&_PID_theta_io, _state_);
    y_theta = _PID_theta_io.y;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>  */
    _PID_psi_io.dt = Demux1;
    _PID_psi_io.u = Demux1;
    _PID_psi_io.Kp = Demux1;
    _PID_psi_io.Ki = Demux1;
    _PID_psi_io.Kd = Demux1;
    PID_psi_compute(&_PID_psi_io, _state_);
    y_psi = _PID_psi_io.y;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Mux>  */
    y[0] = y_z;
    y[1] = y_phi;
    y[2] = y_theta;
    y[3] = y_psi;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<CombinatorialBlock: name=Mux>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SinkBlock: name=y>  */
    for (i1 = 0; i1 < 4; i1++) {
        _io_->y[i1] = y[i1];
    }
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SinkBlock: name=y>  */
    /*  START Block memory write: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
    _state_->t_prev_memory = t;
    /*  END Block memory write: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
}

