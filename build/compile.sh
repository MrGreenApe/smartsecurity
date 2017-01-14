#!/bin/bash

module load libraries/openmpi-1.6-gcc-4.7.0
mpicc Source.c -o source -lssl -lcrypto
