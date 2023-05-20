#include "extras.h"

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>

struct pos_sensor {
    sensor sensor;
    int index;
};

// Used in conjunction with filter() and free_sensors() function
void del_sensor(void *s)
{
    free(((sensor *)s)->operations_idxs);
    free(((sensor *)s)->sensor_data);
}

static void read_one_sensor(sensor *sensor, FILE *in)
{
    fread(&sensor->sensor_type, sizeof(int), 1, in);

    size_t sensor_data_size = sensor->sensor_type == PMU ?
        sizeof(power_management_unit) :
        sizeof(tire_sensor);

    // Allocate enough memory to hold sensor specific data
    sensor->sensor_data = malloc(sensor_data_size);
    assert(sensor->sensor_data);

    fread(sensor->sensor_data, sensor_data_size, 1, in);
    fread(&sensor->nr_operations, sizeof(int), 1, in);

    // Allocate memory to hold operation indices
    sensor->operations_idxs = (int *)malloc(sensor->nr_operations * sizeof(int));
    assert(sensor->operations_idxs);

    fread(sensor->operations_idxs, sizeof(int), sensor->nr_operations, in);
}

static int sensor_cmp(const void *a, const void *b) {
    // Comparator used to sort sensor array in the desired order
    const struct pos_sensor *sensor_a = a, *sensor_b = b;

    if (sensor_a->sensor.sensor_type != sensor_b->sensor.sensor_type) {
        return sensor_a->sensor.sensor_type == PMU ? -1 : 1;
    }

    return sensor_a->index - sensor_b->index;
}

sensor *read_sensors(char *filename, int *nsensors)
{
    FILE *in = fopen(filename, "rb");
    assert(in);

    int num_sensors;
    fread(&num_sensors, sizeof(int), 1, in);

    *nsensors = num_sensors;

    // Keep track of indices in original array to account for relative order
    // when sorting
    struct pos_sensor *tmp_sensor_arr;

    tmp_sensor_arr = (struct pos_sensor *)malloc(sizeof(*tmp_sensor_arr) *
        num_sensors);
    assert(tmp_sensor_arr);

    // Read individual sensors from data file
    for (int i = 0; i < num_sensors; i++) {
        tmp_sensor_arr[i].index = i;

        sensor *sensor = &tmp_sensor_arr[i].sensor;
        read_one_sensor(sensor, in);
    }

    fclose(in);

    // Sort the sensors, preserving the relative order
    qsort(tmp_sensor_arr, num_sensors, sizeof(*tmp_sensor_arr), sensor_cmp);

    // Construct the final array
    sensor *sensors = (sensor *)malloc(sizeof(sensor) * num_sensors);
    assert(sensors);

    for (int i = 0; i < num_sensors; i++)
        sensors[i] = tmp_sensor_arr[i].sensor;

    free(tmp_sensor_arr);
    return sensors;
}

// Remove the items that do not satisfy the predicate from the array
// Return the new array
void *filter(void *arr, int *nitems, size_t size, int (*predicate)(void *),
			 void (*destructor)(void *))
{
    int item_cnt = *nitems;
    void *read_head = arr, *write_head = arr;

    while (item_cnt--) {
        if (predicate(read_head)) {
            // Save the current element
            memcpy(write_head, read_head, size);
            write_head += size;
        } else {
            // Discard the current element
            destructor(read_head);
            (*nitems)--;
        }

        read_head += size;
    }

    arr = realloc(arr, size * (*nitems));
    assert(arr);
    return arr;
}

void free_sensors(sensor *sensors, int nsensors)
{
    sensor *sensor_iter = sensors;
    while (nsensors--) {
        del_sensor(sensor_iter);
        sensor_iter++;
    }

    free(sensors);
}

static void print_sensor(sensor *sensor) {
    if (sensor->sensor_type == PMU) {
        // Sensor is PMU sensor, get and print its 5 fields
		power_management_unit *sensor_data =
			(power_management_unit *)sensor->sensor_data;

		printf("Power Management Unit\n");
		printf("Voltage: %.2f\n", sensor_data->voltage);
		printf("Current: %.2f\n", sensor_data->current);
		printf("Power Consumption: %.2f\n", sensor_data->power_consumption);
		printf("Energy Regen: %d%%\n", sensor_data->energy_regen);
		printf("Energy Storage: %d%%\n", sensor_data->energy_storage);
	} else {
        // Sensor is tyre sensor, get and print its 4 fields
		tire_sensor *sensor_data = (tire_sensor *)sensor->sensor_data;

		printf("Tire Sensor\n");
		printf("Pressure: %.2f\n", sensor_data->pressure);
		printf("Temperature: %.2f\n", sensor_data->temperature);
		printf("Wear Level: %d%%\n", sensor_data->wear_level);

		if (sensor_data->performace_score == 0) {
			printf("Performance Score: Not Calculated\n");
		} else {
			printf("Performance Score: %d\n", sensor_data->performace_score);
		}
	}
}

static void analyze_sensor(sensor *sensor)
{
	void (*ops[8])(void *);

	get_operations((void **)ops);

	for (int i = 0; i < sensor->nr_operations; i++)
		ops[sensor->operations_idxs[i]](sensor->sensor_data);
}

// Return 1 if the sensor is functional, 0 if malfunctioning.
// Used in conjunction with filter() function
static int sensor_is_functional(void *s)
{
    const sensor *sensor = s;
	if (sensor->sensor_type == TIRE) {
        tire_sensor *data = (tire_sensor *)sensor->sensor_data;

        // Check all three bounds
        return data->pressure >= 19 && data->pressure <= 28 &&
			data->temperature >= 0 && data->temperature <= 120 &&
			data->wear_level >= 0 && data->wear_level <= 100;
	} else if (sensor->sensor_type == PMU) {
        power_management_unit *data = (power_management_unit *)sensor->sensor_data;

        // Check all 5 bounds
		return data->voltage >= 10 && data->voltage <= 20 &&
			data->current >= -100 && data->current <= 100 &&
			data->power_consumption >= 0 && data->power_consumption <= 1000 &&
			data->energy_regen >= 0 && data->energy_regen <= 100 &&
			data->energy_storage >= 0 && data->energy_storage <= 100;
	}

    // This should not be reached
    return 0;
}

int exec_cmd(char *cmd, sensor **sensors, int *nsensors)
{
    // Parse the command name
    const char *delims = "\n ";
    char *cmd_name = strtok(cmd, delims);

    // Check the command name against known commands and execute if found
    if (strcmp(cmd_name, "exit") == 0) {
        return 0;
    } else if (strcmp(cmd_name, "print") == 0) {
        // Parse index and check bounds

        int idx = atoi(strtok(NULL, delims));
        if (idx >= *nsensors || idx < 0) 
			printf("Index not in range!\n");
		else
            print_sensor(&(*sensors)[idx]);
    } else if (strcmp(cmd_name, "clear") == 0) {
        // Call filter

        *sensors = filter(*sensors, nsensors, sizeof(sensor),
            sensor_is_functional, del_sensor);
    } else if (strcmp(cmd_name, "analyze") == 0) {
        // Parse index and check bounds

        int idx = atoi(strtok(NULL, delims));
        if (idx >= *nsensors || idx < 0) 
			printf("Index not in range!\n");
		else
            analyze_sensor(&(*sensors)[idx]);
    }

    return 1;
}
