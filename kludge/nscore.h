#include "prtypes.h"

typedef PRUint32 nsresult;

#define nsnull 0
#define NS_COM

#include "nsError.h"


/**
 * Helpful array length function for calculating the length of a
 * statically declared array.
 */

#define NS_ARRAY_LENGTH(array_) \
(sizeof(array_)/sizeof(array_[0]))