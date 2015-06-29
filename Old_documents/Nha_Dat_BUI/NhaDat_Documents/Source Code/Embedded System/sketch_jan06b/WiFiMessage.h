/*********************************
 * Ground Station message        *
 * control characters            *
 * ============================= *
 * BUI Nha-Dat @ HCMUT/ENSMA     *
 * Quadricopter project          *
 * Last modified : 2014-Jan-10   *
 *********************************/

// Control characters must be different from
// hex-based figures: '0' - '9' and 'A' - 'F'
//                   0x30 - 0x39   0x41 - 0x46

#define STX   0x02
#define EOT   0x04
#define ETB   0x17
//#define CR    0x0D
//#define LF    0x0A
#define ORDER 0x4F
#define GAINS 0x47
//#define YGAIN 0x59
//#define PGAIN 0x50
//#define RGAIN 0x52
#define MODE  0x4D
