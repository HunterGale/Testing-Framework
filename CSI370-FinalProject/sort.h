// A program that compares various sorting algorithms written in Assembly and C++
// CSI370 - Final Project
// Author: Cameron LaBounty & Hunter Gale
// Date: 12/4/2022

#ifndef SORT_H
#define SORT_H

#include <algorithm>
#include <random>

using namespace std;

// setup random number generator
static random_device rd;
static mt19937 rng(rd());

void bubbleSort(int array[], const int length) {
    for (int i = 0; i < length - 1; i++) {
        for (int j = 0; j < length - 1 - i; j++) {
            if (array[j] > array[j + 1])
                swap(array[j], array[j + 1]);
        }
    }
}

void selectionSort(int array[], const int length) {
    for (int i = 0; i < length - 1; i++) {
        int minIndex = i;
        for (int j = i + 1; j < length; j++) {
            if (array[j] < array[minIndex])
                minIndex = j;
        }
        swap(array[i], array[minIndex]);
    }
}

void shellSort(int array[], const int length) {
    // C++ implementation taken from here
    // https://www.geeksforgeeks.org/shellsort/
    
    // Start with a big gap, then reduce the gap
    for (int gap = length / 2; gap > 0; gap /= 2)
    {
        // Do a gapped insertion sort for this gap size.
        // The first gap elements a[0..gap-1] are already in gapped order
        // keep adding one more element until the entire array is
        // gap sorted
        for (int i = gap; i < length; i += 1)
        {
            // add a[i] to the elements that have been gap sorted
            // save a[i] in temp and make a hole at position i
            int temp = array[i];

            // shift earlier gap-sorted elements up until the correct
            // location for a[i] is found
            int j;
            for (j = i; j >= gap && array[j - gap] > temp; j -= gap)
                array[j] = array[j - gap];

            //  put temp (the original a[i]) in its correct location
            array[j] = temp;
        }
    }
}

void quickSort(int array[], const int start, const int end) {
    // Base Case: 0 or 1 elements in the array
    if (start >= end)
        return;

    // Recursive Case: choose a random pivot and partion the array into a section with
    // elements less than the pivot and a section with elements greater than the pivot
    // generate the random pivot
    uniform_int_distribution<> distr(start, end);
    int pivot = distr(rng);

    // move the pivot to the front
    swap(array[pivot], array[start]);

    // swap all elements smaller than the pivot with the first element that is larger than it
    int lastSmaller = start;
    for (int i = start + 1; i <= end; i++) {
        if (array[i] < array[start]) {
            swap(array[i], array[lastSmaller + 1]);
            lastSmaller++;
        }
    }

    // move the pivot to it's correct position
    swap(array[start], array[lastSmaller]);

    // sort the partions
    quickSort(array, start, lastSmaller - 1);
    quickSort(array, lastSmaller + 1, end);
}

void mergeSort(int array[], const int start, const int end) {
    // Base Case: 0 or 1 elements in the array
    if (start >= end)
        return;

    // Recursive Case: sort each half of the array and merge them back together
    int middle = (start + end) / 2;
    mergeSort(array, start, middle);
    mergeSort(array, middle + 1, end);
    inplace_merge(array + start, array + middle + 1, array + end + 1);
}

#endif