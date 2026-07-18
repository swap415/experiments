#!/bin/bash
# builds the weighted-scheduler workqueue.so from patched source copies
set -e
cd "$(dirname "$0")"
mkdir -p build
gcc -O2 -fPIC -pthread -I/usr/include/python3.12 -c src/np/ufunc/workqueue.c -o build/workqueue.o
g++ -O2 -fPIC -pthread -c src/np/ufunc/gufunc_scheduler.cpp -o build/gufunc_scheduler.o
g++ -shared -pthread build/workqueue.o build/gufunc_scheduler.o \
    -o build/workqueue.cpython-312-x86_64-linux-gnu.so
echo "built: build/workqueue.cpython-312-x86_64-linux-gnu.so"
