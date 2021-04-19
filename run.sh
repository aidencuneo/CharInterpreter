#!/bin/bash

gcc src/char.c -o bin/char -O2
if [[ $? != 0 ]]; then exit; fi
bin/char $@
