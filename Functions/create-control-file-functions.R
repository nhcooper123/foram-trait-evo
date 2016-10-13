@ For a given row, create a string in the form "variable name = value,"
@ Input is row of a dataframe created by find.all.combinations
@ Output is a string to add to dataframe

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