# Functions to create multiple control files for BAMM analyses
# Requires generateControlFile_fossils.R
# Natalie Cooper

# Get all possible parameter combinations from an input list of possible values
all.parameter.combinations <- function(...) {
  # Get list of variable names entered into function
  variables <- substitute(list(...))[-1]
  var.names <- sapply(variables, deparse)
  # Use expand.grid to get all combinations of parameters possible and add names
  all.options <- expand.grid(...)
  names(all.options) <- var.names
  return(all.options)
}

# Create file names for each control file
name.control.file <- function(prefix, row) {
  paste(prefix, "_", row, ".txt", sep = "")
}

# Create new dataframe with column to add names of control files
build.control.details <- function(combinations) {
  nrows <- nrow(combinations)
  control.details <- combinations
  control.details$control.file.name <- rep("NA", nrows)
  return(control.details)
}

# Add names of control files to column in dataframe
add.control.details <- function(control.details, row, filename) {
  control.details$control.file.name[row] <- filename
  return(control.details)
}

# Create control files for all parameter combinations
# Input names must match those in the control file template
# type = "diversification" or "trait"
# prefix and suffix should aid identification of batches
# prefix is added to each control file name
# suffix is added to the end of the control file details file name
# Output files will go to your working directory
all.control.files <- function(type = type, prefix = "control", suffix = "", ...) {
  
  # Create dataframe with all possible parameter combinations
  combinations <- all.parameter.combinations(...)
  
  # Create dataframe to enter details of control files and their names
  control.details <- build.control.details(combinations)
  
  # Extract number of rows (parameter combinations) and columns (parameters being changed)
  nrows <- nrow(combinations)
  nvars <- ncol(combinations)

  # Loop through each combination to create control files for each
  for(i in 1:nrows){
    # Name control files and add name to control file details dataframe
    filename <- name.control.file(prefix, i)
    control.details <- add.control.details(control.details, i, filename)
    # Generate the control file
    generateControlFile_fossils(file = filename, type = type,
                                params = as.list(c(combinations[i, 1:nvars], 
                                                 outName = filename))) 
  }
  
  # Output the list of control file names and details
  write.table(file = paste("controlfiles_", suffix, ".csv", sep = ""), control.details, sep = ",", row.names = FALSE, 
              col.names = TRUE, quote = FALSE) 
}

# Example of usage 
# 1 - Input parameters you want to tweak and range of values to try
# numberOfGenerations <- seq(10000, 15000, by = 1000)
# observationTime <- c(100, 200)
# treefile <- c("whale.tre", "whale_resolved.tre")
# 2 - Create control files
# all.control.files(type = "diversification", prefix = "control", suffix = "Oct16", 
#                   treefile, observationTime, numberOfGenerations)