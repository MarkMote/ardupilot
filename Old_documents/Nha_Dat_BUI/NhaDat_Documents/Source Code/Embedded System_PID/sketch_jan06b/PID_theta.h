
#ifndef __PID_theta__
#define __PID_theta__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void PID_theta_init(t_PIDcontroller_state *_state_);
extern void PID_theta_compute(t_PID_theta_io *_io_, t_PIDcontroller_state *_state_);


#endif
