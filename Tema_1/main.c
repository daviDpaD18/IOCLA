#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "extras.h"
#include "structs.h"

#define COMMAND_SIZE 128

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "Invalid arguments\n");
		return -1;
	}

	sensor *sensors;
	int nsensors;
	sensors = read_sensors(argv[1], &nsensors);

	char command[COMMAND_SIZE];

	while (fgets(command, COMMAND_SIZE - 1, stdin))
		if (exec_cmd(command, &sensors, &nsensors) == 0)
			break;

	free_sensors(sensors, nsensors);
	return 0;
}
