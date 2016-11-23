#!/bin/bash

if [ -n ~/.ptpython ]; then
    mkdir -p ~/.ptpython
fi

cp -f ../.ptpython/config.py ~/.ptpython/
