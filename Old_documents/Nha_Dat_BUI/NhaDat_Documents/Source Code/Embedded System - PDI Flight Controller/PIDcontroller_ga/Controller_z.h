
#ifndef __Controller_z__
#define __Controller_z__

/* Includes */

#include "GATypes.h"
#include "PIDcontroller_types.h"


/* Function prototypes */

extern void Controller_z_init(t_PIDcontroller_state *_state_);
extern void Controller_z_compute(t_Controller_z_io *_io_, t_PIDcontroller_state *_state_);


#endif
