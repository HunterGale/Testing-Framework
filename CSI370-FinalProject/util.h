// A program that compares various sorting algorithms written in Assembly and C++
// CSI370 - Final Project
// Author: Cameron LaBounty & Hunter Gale
// Date: 12/12/2022

#ifndef UTIL_H
#define UTIL_H

#include <random>
#include <algorithm>

using namespace std;

// setup random number generator
static random_device rd;
static mt19937 rng(rd());

int randomInRange(int start, int end) {
	uniform_int_distribution<> distr(start, end);
	return distr(rng);
}

// Credit: https://stackoverflow.com/a/24192835
string formatWithCommas(long long int value) {
	auto s = to_string(value);
	int n = s.length() - 3;
	int end = (value >= 0) ? 0 : 1;
	while (n > end) {
		s.insert(n, ",");
		n -= 3;
	}
	return s;
}

#endif