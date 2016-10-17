# Running batches of BAMM files in Terminal

The code below will run all control files through BAMM in one batch. 

It assumes that you have a folder called `BAMM` which contains:

* A subfolder called `ControlFiles/` which contains control files as text files. ONLY control files may be in the `ControlFiles/` folder as `.txt` or the code will try to run them as control files
* A subfolder called `BAMM_Outputs/` where the output files will be placed
* Phylogenetic trees and sampling files (if needed)
* The `run_BAMM.sh` script

You then run the script from the BAMM folder (use `cd` to change the directory) in Terminal using:

```r
bash run_BAMM.sh
```

Single runs of control files can be done using:

```r
bamm -c control.txt
```

Note that the phylogeny (and sampling files) still need to be in the folder you are running BAMM from.