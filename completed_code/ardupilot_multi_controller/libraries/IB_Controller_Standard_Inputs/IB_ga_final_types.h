
#ifndef __IB_ga_final_types__
#define __IB_ga_final_types__

/* Includes */

#include "GATypes.h"


/* Type declarations */

typedef struct {
    GAREAL angles[3];
    GAREAL anglesdot[3];
    GAREAL position[3];
    GAREAL positiondot[3];
    GAREAL positiondotdot[3];
    GAREAL angles_desired[3];
    GAREAL position_desired[3];
    GAREAL t;
    GAREAL params[36];
    GAREAL omgs[4];
    GAREAL U1;
    GAREAL U2;
    GAREAL U3;
    GAREAL U4;
    GAREAL not_used[12];
} t_IB_ga_final_io;
#define HAVE_STRUCT_t_IB_ga_final_io


typedef struct {
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay3>  */
    GAREAL Unit_Delay3_memory[3];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_1[3];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay4>  */
    GAREAL Unit_Delay4_memory[3];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_4;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_5;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_6;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn5>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_7;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_4;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_5;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_6;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn5>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_7;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Integrator 2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Integrator 2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_8;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay5>  */
    GAREAL Unit_Delay5_memory[3];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_4;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_5;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_6;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_7;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_8;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn5>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_9;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_4;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_5;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_6;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Equiv_TransferFn5>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_7;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay6>  */
    GAREAL Unit_Delay6_memory[3];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_8[4];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_9;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SinkBlock: name=Scope2>  */
    GAREAL Scope2_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_1[3];
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=fn1>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_10;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_11;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_12;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_9;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_10;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_11;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Integrator 1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_10;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Integrator 1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_13;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_11;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_12;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_13;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_8;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_9;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_10;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=X POSITION CONTROL\nIB>/<SystemBlock: name=X Position Control>/<SinkBlock: name=Scope3>  */
    GAREAL Scope3_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_14;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_15;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_16;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_12;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_13;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_14;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope5>  */
    GAREAL Scope5_memory;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Integrator 1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_14;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Integrator 1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_17;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_15;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_16;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_17;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_11;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_12;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_13;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope4>  */
    GAREAL Scope4_memory_1;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope6>  */
    GAREAL Scope6_memory;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope2>  */
    GAREAL Scope2_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory_4;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=Y POSITION CONTROL\nIB>/<SystemBlock: name=Y Position Control ga>/<SinkBlock: name=Scope3>  */
    GAREAL Scope3_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SinkBlock: name=Scope4>  */
    GAREAL Scope4_memory_2;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_18;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_19;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_20;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_21;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_22;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_23;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_24;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_25;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_26;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_15;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_16;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_17;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_18;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_19;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_20;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_21;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_22;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay7>  */
    GAREAL Unit_Delay7_memory_23;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Integrator 1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_18;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Integrator 2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_19;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Integrator 2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_20;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Integrator 1>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_27;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Integrator 2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_28;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Integrator 2>/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_29;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_21;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_22;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_23;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_24;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_25;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_26;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_27;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_28;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_29;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_14;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_15;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Pitch Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_16;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_17;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_18;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_19;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn1>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_20;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn2>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_21;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Yaw Control >/<SystemBlock: name=Equiv_TransferFn4>/<SequentialBlock: name=Unit Delay8>  */
    GAREAL Unit_Delay8_memory_22;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_4;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory_5;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SystemBlock: name=Roll Control>/<SinkBlock: name=Scope2>  */
    GAREAL Scope2_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SinkBlock: name=Scope4>  */
    GAREAL Scope4_memory_3;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SinkBlock: name=Scope1>  */
    GAREAL Scope1_memory_5;
    /*  Block: <SystemBlock: name=IB_ga_final>/<SystemBlock: name=ATTITUDE CONTROL\nIB>/<SinkBlock: name=Scope2>  */
    GAREAL Scope2_memory_4;
} t_IB_ga_final_state;
#define HAVE_STRUCT_t_IB_ga_final_state


typedef struct {
    GAREAL U1;
    GAREAL x;
    GAREAL xd;
    GAREAL fcs[6];
    GAREAL x_consts[3];
    GAREAL thetad;
} t_X_POSITION_CONTROL_IB_io;
#define HAVE_STRUCT_t_X_POSITION_CONTROL_IB_io


typedef struct {
    GAREAL U1;
    GAREAL y;
    GAREAL yd;
    GAREAL fcs[6];
    GAREAL y_consts[3];
    GAREAL phid;
} t_Y_POSITION_CONTROL_IB_io;
#define HAVE_STRUCT_t_Y_POSITION_CONTROL_IB_io


typedef struct {
    GAREAL angles[6];
    GAREAL thetad;
    GAREAL phid;
    GAREAL psid;
    GAREAL omgs[4];
    GAREAL fcs[6];
    GAREAL att_consts[9];
    GAREAL U2;
    GAREAL U3;
    GAREAL U4;
} t_ATTITUDE_CONTROL_IB_io;
#define HAVE_STRUCT_t_ATTITUDE_CONTROL_IB_io




#endif
