
#ifndef __Y_POSITION_CONTROL_nIB__
#define __Y_POSITION_CONTROL_nIB__

/* Includes */

#include "GATypes.h"
#include "IB_ga_final_types.h"
#include "IB_ga_final_param.h"


/* Function prototypes */

extern void Y_POSITION_CONTROL_IB_init(t_IB_ga_final_state *_state_);
extern void Y_POSITION_CONTROL_IB_compute(t_Y_POSITION_CONTROL_IB_io *_io_, t_IB_ga_final_state *_state_);


#endif
