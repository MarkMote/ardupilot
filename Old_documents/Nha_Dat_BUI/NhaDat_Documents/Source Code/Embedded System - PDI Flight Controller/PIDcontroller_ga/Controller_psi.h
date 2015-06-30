
#ifndef __Controller_psi__
#define __Controller_psi__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void Controller_psi_init(t_PIDcontroller_state *_state_);
extern void Controller_psi_compute(t_Controller_psi_io *_io_, t_PIDcontroller_state *_state_);


#endif
