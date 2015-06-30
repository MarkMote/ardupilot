
#ifndef __PID_z__
#define __PID_z__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void PID_z_init(t_PIDcontroller_state *_state_);
extern void PID_z_compute(t_PID_z_io *_io_, t_PIDcontroller_state *_state_);


#endif
