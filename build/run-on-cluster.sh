#!/bin/bash

qsub -cwd -pe openmpi*1 7 run.sh
