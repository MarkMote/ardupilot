
#ifndef __IB_ga_final__
#define __IB_ga_final__

/* Includes */

#include "GATypes.h"
#include "IB_ga_final_types.h"
#include "X_POSITION_CONTROL_nIB.h"
#include "Y_POSITION_CONTROL_nIB1.h"
#include "ATTITUDE_CONTROL_nIB.h"
#include "IB_ga_final_param.h"
#include <math.h>


/* Function prototypes */

extern void IB_ga_final_init(t_IB_ga_final_state *_state_);
extern void IB_ga_final_compute(t_IB_ga_final_io *_io_, t_IB_ga_final_state *_state_);


#endif
