#include "pch.h"
#include "../CSI370-FinalProject/sort.h"

extern "C" void asmBubbleSort(int array[], const int length);
extern "C" void asmSelectionSort(int array[], const int length);
extern "C" void asmShellSort(int array[], const int length);
extern "C" void asmQuickSort(int array[], const int start, const int end);
extern "C" void asmMergeSort(int array[], int temp[], const int start, const int end);

extern "C" int _randomInRange(int start, int end) {
	return randomInRange(start, end);
}

TEST(SortTests, SelectionSortCPP) {
	const int N = 10000;
	
	// Fill array with N elements
	int sortedArray[N];
	for (int i = 0; i < N; i++) {
		sortedArray[i] = i;
	}

	// Create an shuffled array from sorted array
	int shuffledArray[N];
	copy(sortedArray, sortedArray + N, shuffledArray);

	// Randomize the array
	srand(time(0));
	random_shuffle(begin(shuffledArray), end(shuffledArray));

	// Now run the sorting alg on shuffled array
	selectionSort(shuffledArray, N);

	// Test if they are equal
	for (int i = 0; i < N; ++i) {
		EXPECT_EQ(sortedArray[i], shuffledArray[i]) << "Arrays differ at index " << i;
	}
}

TEST(SortTests, SelectionSortASM) {
	const int N = 10000;

	// Fill array with N elements
	int sortedArray[N];
	for (int i = 0; i < N; i++) {
		sortedArray[i] = i;
	}

	// Create an shuffled array from sorted array
	int shuffledArray[N];
	copy(sortedArray, sortedArray + N, shuffledArray);

	// Randomize the array
	srand(time(0));
	random_shuffle(begin(shuffledArray), end(shuffledArray));

	// Now run the sorting alg on shuffled array
	asmSelectionSort(shuffledArray, N);

	// Test if they are equal
	for (int i = 0; i < N; ++i) {
		EXPECT_EQ(sortedArray[i], shuffledArray[i]) << "Arrays differ at index " << i;
	}
}

TEST(SortTests, BogoSort) {
	const int N = 10000;

	// Fill array with N elements
	int sortedArray[N];
	for (int i = 0; i < N; i++) {
		sortedArray[i] = i;
	}

	// Create an shuffled array from sorted array
	int shuffledArray[N];
	copy(sortedArray, sortedArray + N, shuffledArray);

	// Randomize the array
	srand(time(0));
	random_shuffle(begin(shuffledArray), end(shuffledArray));

	// Now run the sorting alg on shuffled array
	//call BogoSort on (shuffledArray, N);

	// Test if they are equal
	for (int i = 0; i < N; ++i) {
		EXPECT_EQ(sortedArray[i], shuffledArray[i]) << "Arrays differ at index " << i;
	}
}