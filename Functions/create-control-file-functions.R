# Functions to create flexible control files for BAMM analyses

# Get all possible parameter combinations from an input list of possible values
all.combinations <- function(...){
  # Get list of variable names entered into function
  # This may vary depending on what we want to enter
  # May need to modify to add tree file and other vital variables to make requirment???####
  variables <- substitute(list(...))[-1]
  var.names <- sapply(variables, deparse)

  # Use expand.grid to get all combinations of parameters possible and create dataframe
  # Name using input names
  all.options <- expand.grid(...)
  names(all.options) <- var.names
  
  return(all.options)
}

numberOfGenerations <- seq(10000, 15000, by = 1000)
observationTime <- c(100, 200, 350)

qq <- all.combinations(observationTime, numberOfGenerations)

generateControlFile_fossils(file = 'control.txt', type = 'diversification',
                            params = as.list(qq[18,1:2]))