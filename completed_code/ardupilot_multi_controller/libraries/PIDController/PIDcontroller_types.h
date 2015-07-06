
#ifndef __PIDcontroller_types__
#define __PIDcontroller_types__

/* Includes */

#include "GATypes.h"


/* Type declarations */

typedef struct {
    GAREAL t;
    GAREAL e[4];
    GAREAL gains[12];
    GAREAL y[4];
} t_PIDcontroller_io;
#define HAVE_STRUCT_t_PIDcontroller_io


typedef struct {
    /*  Block: <SystemBlock: name=PIDcontroller>/<SequentialBlock: name=t_prev>  */
    GAREAL t_prev_memory;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_1;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_2;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_3;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_4;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    GAREAL y_prev_memory_1;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    GAREAL y_prev_memory_2;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    GAREAL y_prev_memory_3;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Intergrator>/<SequentialBlock: name=y_prev>  */
    GAREAL y_prev_memory_4;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_phi>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_5;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_psi>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_6;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_theta>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_7;
    /*  Block: <SystemBlock: name=PIDcontroller>/<SystemBlock: name=PID_z>/<SystemBlock: name=Derivative>/<SequentialBlock: name=u_prev>  */
    GAREAL u_prev_memory_8;
} t_PIDcontroller_state;
#define HAVE_STRUCT_t_PIDcontroller_state




#endif
