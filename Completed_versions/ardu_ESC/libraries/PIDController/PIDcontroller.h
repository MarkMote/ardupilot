
#ifndef __PIDcontroller__
#define __PIDcontroller__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"



/* Function prototypes */

extern void PIDcontroller_init(t_PIDcontroller_state *_state_);
extern void PIDcontroller_compute(t_PIDcontroller_io *_io_, t_PIDcontroller_state *_state_);
#endif
