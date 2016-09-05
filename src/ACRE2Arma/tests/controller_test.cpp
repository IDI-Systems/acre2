#include "shared.hpp"
#include "lodepng.h"

unsigned long upper_power_of_two(unsigned long v)
{
	v--;
	v |= v >> 1;
	v |= v >> 2;
	v |= v >> 4;
	v |= v >> 8;
	v |= v >> 16;
	v++;
	return v;
}

int main(int argc, char **argv) {
	std::cout << upper_power_of_two(257);
	getchar();
	return 0;
}