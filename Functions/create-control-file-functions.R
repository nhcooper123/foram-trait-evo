# Functions to create flexible control files for BAMM analyses

# Get all possible parameter combinations from an input list of possible values
all.parameter.combinations <- function(treefile, ...){
  # Get list of variable names entered into function
  # This may vary depending on what we want to enter
  # May need to modify to add tree file and other vital variables to make requirment???####
  variables <- substitute(list(...))[-1]
  var.names <- c(treefile, sapply(variables, deparse)

  # Use expand.grid to get all combinations of parameters possible and create dataframe
  # Name using input names
  all.options <- expand.grid(...)
  names(all.options) <- var.names
  
  return(all.options)
}

# Input is a list of variables already defined for entry into the control file
# Requires treefile, the rest are optional
# Names must match those in the control file template
# type = "diversification" or "trait"
all.control.files <- function(..., type = type) {
  # Create dataframe with all possible parameter combinations
  combinations <- all.parameter.combinations(...)
  # Extract number of rows (combinations) and columns (options being changed)
  nrows <- nrow(combinations)
  nvars <- ncol(combinations)
  # Loop through each combination to create control files for each
  for(i in 1:nrows){
    # Need to name control files sensibly and/or place in separate folder
    filename <- "control.txt"
    generateControlFile_fossils(file = filename, type = type,
                                params = as.list(c(combinations[i, 1:nvars]), 
                                                 outName = filename)
    write.table(control.files.txt) # Create a table of all the options in each file? Migth be easier than naming
  }
}

# Example input
# numberOfGenerations <- seq(10000, 15000, by = 1000)
# observationTime <- c(100, 200, 350)
# treefile <- c("whale.tre")

