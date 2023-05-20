#ifndef _EXTRAS_H_
#define _EXTRAS_H_

#include <stdlib.h>
#include "structs.h"

void *filter(void *arr, int *nitems, size_t size, int (*predicate)(void *),
			 void (*destructor)(void *));

// Returns 0 upon receiving exit, 1 otherwise
int exec_cmd(char *cmd, sensor **sensors, int *nsensors);

sensor *read_sensors(char *filename, int *nsensors);

void free_sensors(sensor *sensors, int nsensors);

void del_sensor(void *s);

#endif  // _EXTRAS_H_
