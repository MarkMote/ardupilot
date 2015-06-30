
#ifndef __PID_phi__
#define __PID_phi__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void PID_phi_init(t_PIDcontroller_state *_state_);
extern void PID_phi_compute(t_PID_phi_io *_io_, t_PIDcontroller_state *_state_);


#endif
