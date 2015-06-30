
#ifndef __Altitude_types__
#define __Altitude_types__

/* Includes */

#include "GATypes.h"


/* Type declarations */

typedef struct {
    GAREAL z;
    GAREAL zd;
    GAREAL phi;
    GAREAL theta;
    GAREAL dt;
    GAREAL U1;
} t_Altitude_io;
#define HAVE_STRUCT_t_Altitude_io


typedef struct {
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_1;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_2;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn1>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_3;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay2>  */
    GAREAL Unit_Delay2_memory_4;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn1>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_1;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn2>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_2;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Equiv_TransferFn3>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_3;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=Integrator >/<SequentialBlock: name=Unit Delay1>  */
    GAREAL Unit_Delay1_memory_4;
    /*  Block: <SystemBlock: name=Altitude>/<SystemBlock: name=ALTITUDE CONTROL\nIB1>/<SystemBlock: name=function>/<SinkBlock: name=Scope>  */
    GAREAL Scope_memory;
} t_Altitude_state;
#define HAVE_STRUCT_t_Altitude_state




#endif
