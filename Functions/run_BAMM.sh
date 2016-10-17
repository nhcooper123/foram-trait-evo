#!/bin/bash

FILES=ControlFiles/*

for f in $FILES
do
  bamm -c f
done