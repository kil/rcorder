#include <stdio.h>
#include <time.h>

int
main(int argc, char **argv)
{
	struct timespec		tp;
	double			t;

	if (clock_gettime(CLOCK_MONOTONIC, &tp) == -1) {
		perror("clock_gettime");
		return 1;
	}

	t = (((double) tp.tv_sec) * 1000000000.0 + (double) tp.tv_nsec) / 1000000000.0;
	printf("%f\n", t);
	return 0;
}
