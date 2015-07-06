
#ifndef __MotorSpeed_types__
#define __MotorSpeed_types__

/* Includes */

#include "GATypes.h"


/* Type declarations */

typedef struct {
    GAREAL U1;
    GAREAL U2;
    GAREAL U3;
    GAREAL U4;
    GAREAL omgs2[4];
} t_MotorSpeed_io;
#define HAVE_STRUCT_t_MotorSpeed_io




#endif
