# Functions to create flexible control files for BAMM analyses

# For a given row, create a string in the form "variable name = value,"
create.parameters.string <- function(combinations.row) {
  # Create empty string
  params <- c() 
  # For each variable, create string in form of "variable name = value,"
  for(i in seq_along(names(combinations.row))) {
    params <- str_c(params, names(combinations.row)[i], " = ", 
                    combinations.row[[i]], ", ", sep = "")
  } 
  # Remove extra comma at end of string   
  params <- str_sub(params, end = -3) 
  # Output the string with parameter combinations for the row
  return(params)
}

# Create strings in the form "variable name = value," for whole dataframe 
# and add to parameters column in the dataframe
create.parameters.column <- function(combinations.dataframe) {
  # Extract number of rows in dataframe
  nrows <- nrow(combinations.dataframe)
  # Create empty column to fill with parameter combinations
  parameters <- array(dim = c(nrows,1))
  # Loop through each row to create and store parameter combinations
  for(row.number in 1:nrows) {
    row <- slice(combinations.dataframe, row.number)
    parameters[row.number,] <- create.parameters.string(row)
  }
  # Put parameters into the dataframe and return
  combinations.dataframe$parameters <- parameters
  return(combinations.dataframe)         
}

