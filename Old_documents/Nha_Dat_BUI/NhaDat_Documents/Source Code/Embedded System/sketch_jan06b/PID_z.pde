/*
    PID_z.c
    Generated by Gene-Auto toolset ver 2.4.10
    (launcher GALauncher)
    Generated on: 25/02/2015 16:31:51.524
    source model: PIDcontroller
    model version: 6.5
    last saved by:
    last saved on:
*/

/* Includes */

#include "PID_z.h"

/* Function definitions */

void PID_z_init(t_PIDcontroller_state *_state_) {
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    _state_->u_prev_memory_1 = 0;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    _state_->y_prev_memory_1 = 0;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    _state_->u_prev_memory_2 = 0;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
}

void PID_z_compute(t_PID_z_io *_io_, t_PIDcontroller_state *_state_) {
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=dt>/<OutDataPort: name=>  */
    GAREAL dt;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=u>/<OutDataPort: name=>  */
    GAREAL u;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Kp>/<OutDataPort: name=>  */
    GAREAL Kp;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Ki>/<OutDataPort: name=>  */
    GAREAL Ki;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Kd>/<OutDataPort: name=>  */
    GAREAL Kd;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide>/<OutDataPort: name=>  */
    GAREAL Divide_2;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide1>/<OutDataPort: name=>  */
    GAREAL Divide1;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide2>/<OutDataPort: name=>  */
    GAREAL Divide2;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Sum>/<OutDataPort: name=>  */
    GAREAL Sum;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<CombinatorialBlock: name=Divide>/<OutDataPort: name=>  */
    GAREAL Divide_1;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<CombinatorialBlock: name=Subtract1>/<OutDataPort: name=>  */
    GAREAL Subtract1;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>/<OutDataPort: name=>  */
    GAREAL u_prev_2;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=Add>/<OutDataPort: name=>  */
    GAREAL Add;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=Multiply>/<OutDataPort: name=>  */
    GAREAL Multiply;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=add_u_u_prev>/<OutDataPort: name=>  */
    GAREAL add_u_u_prev;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SourceBlock: name=half>/<OutDataPort: name=>  */
    GAREAL half;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>/<OutDataPort: name=>  */
    GAREAL u_prev_1;
    /*  Output from <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>/<OutDataPort: name=>  */
    GAREAL y_prev;
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SourceBlock: name=half>  */
    half = 0.5;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SourceBlock: name=half>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=dt>  */
    dt = _io_->dt;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=dt>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=u>  */
    u = _io_->u;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=u>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    u_prev_1 = _state_->u_prev_memory_1;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    y_prev = _state_->y_prev_memory_1;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    u_prev_2 = _state_->u_prev_memory_2;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Kp>  */
    Kp = _io_->Kp;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Kp>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide>  */
    Divide_2 = u * Kp;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Ki>  */
    Ki = _io_->Ki;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Ki>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide1>  */
    Divide1 = Divide_2 * Ki;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide1>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=add_u_u_prev>  */
    add_u_u_prev = Divide1 + u_prev_1;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=add_u_u_prev>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=Multiply>  */
    Multiply = dt * half * add_u_u_prev;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=Multiply>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=Add>  */
    Add = Multiply + y_prev;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<CombinatorialBlock: name=Add>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Kd>  */
    Kd = _io_->Kd;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SourceBlock: name=Kd>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide2>  */
    Divide2 = Divide_2 * Kd;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Divide2>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<CombinatorialBlock: name=Subtract1>  */
    Subtract1 = Divide2 - u_prev_2;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<CombinatorialBlock: name=Subtract1>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<CombinatorialBlock: name=Divide>  */
    Divide_1 = Subtract1 / dt;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<CombinatorialBlock: name=Divide>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Sum>  */
    Sum = Divide_2 + Add + Divide_1;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<CombinatorialBlock: name=Sum>  */
    /*  START Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SinkBlock: name=y>  */
    _io_->y = Sum;
    /*  END Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SinkBlock: name=y>  */
    /*  START Block memory write: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    _state_->u_prev_memory_2 = Divide2;
    /*  END Block memory write: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    /*  START Block memory write: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    _state_->y_prev_memory_1 = Add;
    /*  END Block memory write: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    /*  START Block memory write: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    _state_->u_prev_memory_1 = Divide1;
    /*  END Block memory write: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
}

