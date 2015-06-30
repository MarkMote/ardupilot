/*  Gene-Auto data types  */

#ifndef __GATypes__
#define __GATypes__

/* Named Constants */

#define FALSE 0
#define TRUE 1

/* Type declarations */

typedef char GAINT8;

typedef unsigned char GAUINT8;

typedef short GAINT16;

typedef unsigned short GAUINT16;

typedef int GAINT32;

typedef unsigned int GAUINT32;

typedef double GAREAL;

typedef float GASINGLE;

typedef unsigned char GABOOL;


/* Function-like macros */

/*  Conversion to the GABOOL type  */
#define TO_GABOOL(X) ((X) ? 1 : 0)



#endif
