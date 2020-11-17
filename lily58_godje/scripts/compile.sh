#!/bin/bash

if [[ $1 ]]; then
	qmk compile $1
else
	qmk compile
fi
