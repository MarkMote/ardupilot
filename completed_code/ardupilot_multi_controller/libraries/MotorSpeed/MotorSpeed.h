
#ifndef __MotorSpeed__
#define __MotorSpeed__

/* Includes */

#include "GATypes.h"
#include "MotorSpeed_types.h"
#include "MotorSpeed_param.h"
#include <math.h>


/* Variable Declarations */

extern GAREAL U1_2;
extern GAREAL U;
extern GAREAL U2_2;
extern GAREAL omg1_2;
extern GAREAL omg2_2;
extern GAREAL omg;
extern GAREAL U3_2;
extern GAREAL omg3_2;

/* Function prototypes */

extern void MotorSpeed_init();
extern void MotorSpeed_compute(t_MotorSpeed_io *_io_);


#endif
