#!/bin/bash

# Takes each .txt file in ControlFiles/ and runs it through BAMM
# ONLY control files may be in the ControlFiles/ folder as .txt 
# Phylogenetic trees and sampling 
# Moves outputs to BAMM_Outputs folder

FILES=ControlFiles/*.txt

for f in $FILES
do
  echo $f
  bamm -c $f
  mv *.txt BAMM_Outputs/
done