#include <iostream>
#include "sort.h"

using namespace std;

extern "C" void asmMain();

int main() {
	asmMain();
	return EXIT_SUCCESS;
}