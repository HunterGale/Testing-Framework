# Assembly vs C++ Sorting Algorithms
A program that measures and compares the runtime of various sorting algorithms written in Assembly and C++. The sorting algorithms we have implemented are Bubble Sort, Selection Sort, Shell Sort, Quick Sort, and Merge Sort. By implementing these algorithms ourselves in Assembly, we aim to empirically demonstrate the efficiency benefits of writing code at a lower level.

## Challenges and Solutions
### Recursive Functions and Stack Management
Two of the algorithms in this project utilize recursion to sort arrays. While this is a convenient and efficient way to sort arrays, it is also much harder to implement at a low level because we can’t safely use registers to save information needed after a recursive function call. Our solution to this problem was to save these important variables in the shadow space on the stack before recursively calling any functions. This is done by moving data in registers to memory locations offset from the stack pointer.

### Non-Constant Space Algorithms
Implementing merge sort in Assembly presented an interesting challenge that we did not initially expect. The Merge Sort algorithm requires O(N) additional space when merging the two halves of the array together. In order to meet this requirement, we allocated additional space in C++ and allowed the Assembly implementation to utilize it when performing the inplace merge.

## Results
Here are the outputs of our program in both debug and release modes. These examples used arrays with 10,000 elements and were run on a modern desktop PC with plenty of processing power. Results will vary depending on the system running the code.

### Debug Mode
![results_debug](https://user-images.githubusercontent.com/45549407/209286140-ddd18aa5-c399-452b-abb4-d4874544aece.png)

### Release Mode
![results_release](https://user-images.githubusercontent.com/45549407/209287891-7dce99f9-aa4b-4f1c-a2e4-9cfa8f6c32dc.PNG)

As you can see, in debug mode, our Assembly implementations were always faster than the C++. In release mode, the compiler beat us in Bubble Sort, Shell Sort, and Quick Sort, while our Selection Sort and Merge Sort were both faster than the compiler could do. We were not very surprised with these results, especially considering we could’ve made our assembly code more efficient in many ways but chose to stay close to representing the C++ implementations. All in all, this project demonstrates that sometimes you can sacrifice ease of implementation and readability for speed by choosing to implement tasks on your own in Assembly over C++.

## Team Members
- Cameron LaBounty
- Hunter Gale
