// A program that compares various sorting algorithms written in Assembly and C++
// CSI370 - Final Project
// Author: Cameron LaBounty & Hunter Gale
// Date: 12/4/2022

#include <iostream>
#include <iomanip>
#include <algorithm>
#include <chrono>
#include "sort.h"

using namespace std;

extern "C" void asmBubbleSort(int array[], const int length);
extern "C" void asmSelectionSort(int array[], const int length);
extern "C" void asmBucketSort(int array[], const int length);
extern "C" void asmQuickSort(int array[], const int start, const int end);
extern "C" void asmMergeSort(int array[], const int start, const int end);

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

	int array[N];
	for (int i = 0; i < N; i++) {
		array[i] = i;
	}
	srand(time(0));
	random_shuffle(begin(array), end(array));

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

	cout << setw(28) << right << "Bubble Sort (C++) = " << formatWithCommas(bubbleSortCppTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Bubble Sort (Assembly) = " << formatWithCommas(bubbleSortAsmTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << formatWithCommas(bubbleSortCppTime - bubbleSortAsmTime) << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Selection Sort (C++) = " << formatWithCommas(selectionSortCppTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Selection Sort (Assembly) = " << formatWithCommas(selectionSortAsmTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << formatWithCommas(selectionSortCppTime - selectionSortAsmTime) << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Bucket Sort (C++) = " << formatWithCommas(bucketSortCppTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Bucket Sort (Assembly) = " << formatWithCommas(bucketSortAsmTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << formatWithCommas(bucketSortCppTime - bucketSortAsmTime) << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Quick Sort (C++) = " << formatWithCommas(quickSortCppTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Quick Sort (Assembly) = " << formatWithCommas(quickSortAsmTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << formatWithCommas(quickSortCppTime - quickSortAsmTime) << " nanoseconds" << endl;
	cout << endl;
	cout << setw(28) << right << "Merge Sort (C++) = " << formatWithCommas(mergeSortCppTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Merge Sort (Assembly) = " << formatWithCommas(mergeSortAsmTime) << " nanoseconds" << endl;
	cout << setw(28) << right << "Difference = " << formatWithCommas(mergeSortCppTime - mergeSortAsmTime) << " nanoseconds" << endl;
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