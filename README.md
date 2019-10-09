# keylist [![Build Status](https://travis-ci.com/skarg/keylist.svg?branch=master)](https://travis-ci.com/skarg/keylist)
Keyed List C Library

This is an enhanced array of pointers to data. 
The list is sorted, indexed, and keyed.
The array is much faster than a linked list.
It stores a pointer to data chunk, which you must
malloc and free on your own, or just use
static data
