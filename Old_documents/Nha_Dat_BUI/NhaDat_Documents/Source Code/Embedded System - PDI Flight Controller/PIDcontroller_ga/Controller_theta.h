
#ifndef __Controller_theta__
#define __Controller_theta__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void Controller_theta_init(t_PIDcontroller_state *_state_);
extern void Controller_theta_compute(t_Controller_theta_io *_io_, t_PIDcontroller_state *_state_);


#endif
