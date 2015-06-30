
#ifndef __Altitude__
#define __Altitude__

/* Includes */

#include "GATypes.h"
#include "Altitude_types.h"
#include "IB_Controller_ga_final_param.h"
#include <math.h>


/* Function prototypes */

extern void Altitude_init(t_Altitude_state *_state_);
extern void Altitude_compute(t_Altitude_io *_io_, t_Altitude_state *_state_);


#endif
