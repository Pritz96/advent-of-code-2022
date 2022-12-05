# Solution to Question 5

library(dplyr)

puzzle_input <- readLines("puzzle_input.txt")

# Find empty line within puzzle to distinguish crate stack data from procedure data
index_of_empty_line <- which(puzzle_input == "")
crate_stacks <- strsplit(puzzle_input[1:(index_of_empty_line - 2)], "\n")
procedures <- strsplit(puzzle_input[(index_of_empty_line + 1):length(puzzle_input)], "\n")

# Function takes in a crate row, splits it into individual characters
# It then extracts either an empty string or a letter based on positioning
# A vector for this row is then returned
vectorise_crate_row <- function(row) {
  split_line <- unlist(strsplit(row, ""))
  
  # Selects the 4th element with an offset of 2
  # The logic for this is that the 4th character of a row is ALWAYS a blank space
  # Therefore when we offset this by 2, we either get an empty string or the letter itself
  final_vector <- split_line[(1:length(split_line) %% 4) == 2]
  
  return(final_vector)
}

# Vectorise each row, transpose the matrix to look like the puzzle input then convert to a dataframe
crates_formatted <- sapply(crate_stacks, vectorise_crate_row)
transposed_crates_formatted <- t(crates_formatted)
puzzle_input_dataframe <- as.data.frame(transposed_crates_formatted, stringsAsFactors = FALSE)


concatenate_crate_column <- function(crate_column) {
  return(gsub(" ", "", paste(crate_column, collapse = "")))
}
# Create a list of strings, each item in the list is a crate stack
crate_stack_list <- lapply(puzzle_input_dataframe, concatenate_crate_column)

# Loop through all of the procedures
# Extract how many items to move, the first_crate_index and last_crate_index for each procedure
# Performs each procedure on the given crate
# After looping through all of the procedures the function returns the top item in each stack as a concatenated string
# Setting 'part1=FALSE' will give you the answer for Part 2
rearrangement_procedure <- function(crates, procedures, part1 = TRUE) {
  for (x in 1:length(procedures)) {
    split_procedure = unlist(strsplit(procedures[[x]], " "))
    how_many = strtoi(split_procedure[2])
    first_crate_index = strtoi(split_procedure[4])
    last_crate_index = strtoi(split_procedure[6])
    
    first_crate <- crates[[first_crate_index]]
    last_crate <- crates[[last_crate_index]]
    
    extracted_string_from_first_crate <- substr(first_crate, 1, how_many)
    string_split <- strsplit(extracted_string_from_first_crate, NULL)[[1]]
    reversed_string <- paste(rev(string_split), collapse = "")
    
    stack_to_move <-if_else(part1 == TRUE, reversed_string, extracted_string_from_first_crate)
    
    crates[[first_crate_index]] <- substr(first_crate, (how_many + 1), nchar(first_crate))
    crates[[last_crate_index]] <- paste0(stack_to_move, last_crate)
  }
  
  # Creates a vector containing the first item in each stack
  vector_of_top_item_in_each_stack <- lapply(crates, substr, 1, 1)
  
  return(paste(vector_of_top_item_in_each_stack, collapse = ""))
}

print(paste("The crates that end up on the top of each stack for Part 1 are", rearrangement_procedure(crate_stack_list, procedures, TRUE)))
print(paste("The crates that end up on the top of each stack for Part 2 are", rearrangement_procedure(crate_stack_list, procedures, FALSE)))
