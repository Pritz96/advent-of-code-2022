# Solution to Question 6

# Function takes in a vector, and chunks the vector elements into groups (with an overlap)
chunk_vector_into_groups <- function(vector, number_of_groups){
  # For every element of the vector return a vector that contains the element and the following (number_of_groups - 1) elements
  chunked_vector <- lapply(1 : (length(vector) - (number_of_groups - 1)), function(letter){
    return(vector[letter:(letter + (number_of_groups - 1))])
  })
  return(chunked_vector)
}

# Function takes in a list of vectors and returns the index of the first vector where every element of the vector is unique to each other
which_chunks_are_unique <- function(chunked_vector){
  # For every vector in the list of vectors, return TRUE if every element of the vector is unique to each other
  logical_vector <- lapply(chunked_vector, function(vector){
    return(length(unique(vector)) == length(vector))
  })
  # Return the first occurrence (index) of a unique vector 
  return(min(which(logical_vector == TRUE)))
}

# Read in the datastream buffer string and split the string into a vector containing the individual letters
datastream_buffer <- readLines("puzzle_input.txt")
split_datastream <- unlist(strsplit(datastream_buffer, ""))

# For part 1, chunk the datastream buffer vector into chunks of 4 and find the index of the chunk where every item in the chunk is unique
chunked_datastream_part1 <- chunk_vector_into_groups(split_datastream, 4)
index_of_first_unique_chunk_part1 <- which_chunks_are_unique(chunked_datastream_part1)

# For part 2, chunk the datastream buffer vector into chunks of 14 and find the index of the chunk where every item in the chunk is unique
chunked_datastream_part2 <- chunk_vector_into_groups(split_datastream, 14)
index_of_first_unique_chunk_part2 <- which_chunks_are_unique(chunked_datastream_part2)

# Print the output, note that in order to get the character position we add ((group size) -1) to the (index of the first unique chunk)
print(paste(index_of_first_unique_chunk_part1 + 3, "characters need to be processed before the first start-of-packet marker is detected (part 1)"))
print(paste(index_of_first_unique_chunk_part2 + 13, "characters need to be processed before the first start-of-packet marker is detected (part 2)"))
