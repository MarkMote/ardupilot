
#ifndef __PID_psi__
#define __PID_psi__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void PID_psi_init(t_PIDcontroller_state *_state_);
extern void PID_psi_compute(t_PID_psi_io *_io_, t_PIDcontroller_state *_state_);


#endif
