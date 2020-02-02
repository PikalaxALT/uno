#!/bin/sh
# Compares baserom.gbc and uno.gbc

# create baserom.txt if necessary
if [ ! -f baserom.txt ]; then
    hexdump -C baserom.gbc > baserom.txt
fi

hexdump -C uno.gbc > uno.txt

diff -u baserom.txt uno.txt
