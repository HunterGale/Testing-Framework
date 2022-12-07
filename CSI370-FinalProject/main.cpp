// A program that compares various sorting algorithms written in Assembly and C++
// CSI370 - Final Project
// Author: Cameron LaBounty & Hunter Gale
// Date: 12/6/2022

#include <iostream>
#include <iomanip>
#include <string>
#include <algorithm>
#include <chrono>
#include "sort.h"

using namespace std;

extern "C" void asmBubbleSort(int array[], const int length);
extern "C" void asmSelectionSort(int array[], const int length);
extern "C" void asmBucketSort(int array[], const int length);
extern "C" void asmQuickSort(int array[], const int start, const int end);
extern "C" void asmMergeSort(int array[], const int start, const int end);

extern "C" void _inplaceMerge(int array[], int start, int middle, int end) {
	inplace_merge(array + start, array + middle + 1, array + end + 1);
}

enum SORT_ALGORITHM {
	BUBBLE_SORT,
	SELECTION_SORT,
	BUCKET_SORT,
	QUICK_SORT,
	MERGE_SORT
};

enum LANGUAGE {
	ASSEMBLY,
	CPP
};

int timeSort(int array[], const int length, SORT_ALGORITHM algorithm, LANGUAGE language);
void sort(int array[], const int length, SORT_ALGORITHM algorithm, LANGUAGE language);
string formatWithCommas(int value);

int main() {
	const int N = 10000;

	// Fill and shuffle array with N elements
	int array[N];
	for (int i = 0; i < N; i++) {
		array[i] = i;
	}
	srand(time(0));
	random_shuffle(begin(array), end(array));

	// Execute and time each sort algorithm with a copy of the original array
	int arrayCopy[N];
	copy(begin(array), end(array), begin(arrayCopy));
	int bubbleSortCppTime = timeSort(arrayCopy, N, BUBBLE_SORT, CPP);
	copy(begin(array), end(array), begin(arrayCopy));
	int bubbleSortAsmTime = timeSort(arrayCopy, N, BUBBLE_SORT, ASSEMBLY);
	copy(begin(array), end(array), begin(arrayCopy));
	int selectionSortCppTime = timeSort(arrayCopy, N, SELECTION_SORT, CPP);
	copy(begin(array), end(array), begin(arrayCopy));
	int selectionSortAsmTime = timeSort(arrayCopy, N, SELECTION_SORT, ASSEMBLY);
	copy(begin(array), end(array), begin(arrayCopy));
	int bucketSortCppTime = timeSort(arrayCopy, N, BUCKET_SORT, CPP);
	copy(begin(array), end(array), begin(arrayCopy));
	int bucketSortAsmTime = timeSort(arrayCopy, N, BUCKET_SORT, ASSEMBLY);
	copy(begin(array), end(array), begin(arrayCopy));
	int quickSortCppTime = timeSort(arrayCopy, N, QUICK_SORT, CPP);
	copy(begin(array), end(array), begin(arrayCopy));
	int quickSortAsmTime = timeSort(arrayCopy, N, QUICK_SORT, ASSEMBLY);
	copy(begin(array), end(array), begin(arrayCopy));
	int mergeSortCppTime = timeSort(arrayCopy, N, MERGE_SORT, CPP);
	copy(begin(array), end(array), begin(arrayCopy));
	int mergeSortAsmTime = timeSort(arrayCopy, N, MERGE_SORT, ASSEMBLY);

	// Format each value with commas using a helper function
	string bubbleSortCppTimeStr = formatWithCommas(bubbleSortCppTime);
	string bubbleSortAsmTimeStr = formatWithCommas(bubbleSortAsmTime);
	string bubbleSortTimeDiffStr = formatWithCommas(bubbleSortCppTime - bubbleSortAsmTime);
	string selectionSortCppTimeStr = formatWithCommas(selectionSortCppTime);
	string selectionSortAsmTimeStr = formatWithCommas(selectionSortAsmTime);
	string selectionSortTimeDiffStr = formatWithCommas(selectionSortCppTime - selectionSortAsmTime);
	string bucketSortCppTimeStr = formatWithCommas(bucketSortCppTime);
	string bucketSortAsmTimeStr = formatWithCommas(bucketSortAsmTime);
	string bucketSortTimeDiffStr = formatWithCommas(bucketSortCppTime - bucketSortAsmTime);
	string quickSortCppTimeStr = formatWithCommas(quickSortCppTime);
	string quickSortAsmTimeStr = formatWithCommas(quickSortAsmTime);
	string quickSortTimeDiffStr = formatWithCommas(quickSortCppTime - quickSortAsmTime);
	string mergeSortCppTimeStr = formatWithCommas(mergeSortCppTime);
	string mergeSortAsmTimeStr = formatWithCommas(mergeSortAsmTime);
	string mergeSortTimeDiffStr = formatWithCommas(mergeSortCppTime - mergeSortAsmTime);

	// Determine the length of the largest string for spacing
	const int outputStringSizes[] = { 
		bubbleSortCppTimeStr.length(),
		bubbleSortAsmTimeStr.length(),
		bubbleSortTimeDiffStr.length(),
		selectionSortCppTimeStr.length(),
		selectionSortAsmTimeStr.length(),
		selectionSortTimeDiffStr.length(),
		bucketSortCppTimeStr.length(),
		bucketSortAsmTimeStr.length(),
		bucketSortTimeDiffStr.length(),
		quickSortCppTimeStr.length(),
		quickSortAsmTimeStr.length(),
		quickSortTimeDiffStr.length(),
		mergeSortCppTimeStr.length(),
		mergeSortAsmTimeStr.length(),
		mergeSortTimeDiffStr.length()
	};
	int spacing = *max_element(begin(outputStringSizes), end(outputStringSizes));

	// Display output
	cout << setw(28) << right << "Bubble Sort (C++) = " << setw(spacing) << right << bubbleSortCppTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Bubble Sort (Assembly) = " << setw(spacing) << right << bubbleSortAsmTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << setw(spacing) << right << bubbleSortTimeDiffStr << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Selection Sort (C++) = " << setw(spacing) << right << selectionSortCppTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Selection Sort (Assembly) = " << setw(spacing) << right << selectionSortAsmTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << setw(spacing) << right << selectionSortTimeDiffStr << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Bucket Sort (C++) = " << setw(spacing) << right << bucketSortCppTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Bucket Sort (Assembly) = " << setw(spacing) << right << bucketSortAsmTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << setw(spacing) << right << bucketSortTimeDiffStr << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Quick Sort (C++) = " << setw(spacing) << right << quickSortCppTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Quick Sort (Assembly) = " << setw(spacing) << right << quickSortAsmTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << setw(spacing) << right << quickSortTimeDiffStr << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Merge Sort (C++) = " << setw(spacing) << right << mergeSortCppTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Merge Sort (Assembly) = " << setw(spacing) << right << mergeSortAsmTimeStr << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << setw(spacing) << right << mergeSortTimeDiffStr << " nanoseconds" << endl;
	cout << endl;

	return EXIT_SUCCESS;
}

int timeSort(int array[], const int length, SORT_ALGORITHM algorithm, LANGUAGE language) {
	chrono::steady_clock::time_point start = chrono::steady_clock::now();
	sort(array, length, algorithm, language);
	chrono::steady_clock::time_point stop = chrono::steady_clock::now();
	return chrono::duration_cast<chrono::nanoseconds>(stop - start).count();
}

void sort(int array[], const int length, SORT_ALGORITHM algorithm, LANGUAGE language) {
	if (language == ASSEMBLY) {
		switch (algorithm) {
			case BUBBLE_SORT:
				asmBubbleSort(array, length);
				break;
			case SELECTION_SORT:
				asmSelectionSort(array, length);
				break;
			case BUCKET_SORT:
				asmBucketSort(array, length);
				break;
			case QUICK_SORT:
				asmQuickSort(array, 0, length - 1);
				break;
			case MERGE_SORT:
				asmMergeSort(array, 0, length - 1);
				break;
		}
	}
	else {
		switch (algorithm) {
			case BUBBLE_SORT:
				bubbleSort(array, length);
				break;
			case SELECTION_SORT:
				selectionSort(array, length);
				break;
			case BUCKET_SORT:
				bucketSort(array, length);
				break;
			case QUICK_SORT:
				quickSort(array, 0, length - 1);
				break;
			case MERGE_SORT:
				mergeSort(array, 0, length - 1);
				break;
		}
	}
}

// Credit: https://stackoverflow.com/a/24192835
string formatWithCommas(int value) {
	auto s = to_string(value);
	int n = s.length() - 3;
	int end = (value >= 0) ? 0 : 1;
	while (n > end) {
		s.insert(n, ",");
		n -= 3;
	}
	return s;
}