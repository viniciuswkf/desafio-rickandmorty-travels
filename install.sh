#!/bin/bash


# Copy dynamic library dependencies
cp $(ldd ./app/app | awk '/=>/ {print $3}' | xargs) /
./app
