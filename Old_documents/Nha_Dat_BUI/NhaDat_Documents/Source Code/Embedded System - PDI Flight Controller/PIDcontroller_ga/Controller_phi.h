
#ifndef __Controller_phi__
#define __Controller_phi__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void Controller_phi_init(t_PIDcontroller_state *_state_);
extern void Controller_phi_compute(t_Controller_phi_io *_io_, t_PIDcontroller_state *_state_);


#endif
