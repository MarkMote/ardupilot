
#ifndef __IB_Controller_ga_attitude_final_types__
#define __IB_Controller_ga_attitude_final_types__

/* Includes */

#include "GATypes.h"


/* Type declarations */

typedef struct {
    GAREAL angles[6];
    GAREAL thetad;
    GAREAL phid;
    GAREAL psid;
    GAREAL dt;
    GAREAL omgs[4];
    GAREAL U2;
    GAREAL U3;
    GAREAL U4;
} t_IB_Controller_ga_attitude_final_io;
#define HAVE_STRUCT_t_IB_Controller_ga_attitude_final_io


typedef struct {
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_1;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_2;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn4>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_3;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_4;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_5;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_6;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn4>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_7;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_8;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_9;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_10;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn4>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_11;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_12;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_1;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_2;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn4>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_3;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_4;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_5;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_6;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn4>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_7;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_8;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_9;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_10;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn4>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_11;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_12;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_1;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SystemBlock: name=Roll Control>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SinkBlock: name=Scope2>  */
    GAREAL Scope2_memory;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_2;
    /*  Block: <SystemBlock: name=IB_Controller_ga_attitude_final>/<SinkBlock: name=Scope4>  */
    GAREAL Scope4_memory;
} t_IB_Controller_ga_attitude_final_state;
#define HAVE_STRUCT_t_IB_Controller_ga_attitude_final_state




#endif
