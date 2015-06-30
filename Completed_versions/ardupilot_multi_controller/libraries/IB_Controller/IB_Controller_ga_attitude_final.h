
#ifndef __IB_Controller_ga_attitude_final__
#define __IB_Controller_ga_attitude_final__

/* Includes */

#include "GATypes.h"
#include "IB_Controller_ga_attitude_final_types.h"
#include "IB_Controller_ga_final_param.h"
#ifndef PI
 #define PI 3.141592653589793f
#endif


/* Function prototypes */

extern void IB_Controller_ga_attitude_final_init(t_IB_Controller_ga_attitude_final_state *_state_);
extern void IB_Controller_ga_attitude_final_compute(t_IB_Controller_ga_attitude_final_io *_io_, t_IB_Controller_ga_attitude_final_state *_state_);


#endif
