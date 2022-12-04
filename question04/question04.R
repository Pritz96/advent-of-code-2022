# Solution to Question 4

library(dplyr)

# Read in the puzzle input file as a CSV
puzzle_input <- read.csv('puzzle_input.csv', header=FALSE)
colnames(puzzle_input) <- c("first_elf", "second_elf")
# Change the first_elf and second_elf columns from factor w/ levels to character columns
puzzle_input$first_elf <- as.character(puzzle_input$first_elf)
puzzle_input$second_elf <- as.character(puzzle_input$second_elf)

# Function that takes in a section e.g. "94-97" and returns a vector range [94:97]
section_to_range <- function(section){
  section_split <- unlist(strsplit(section, "-"))
  min<- section_split[1]
  max<- section_split[2]
  return(min:max)
}

# Function that takes in the first and second elf range
# Returns TRUE if either range is fully contained within the other
# Returns FALSE otherwise
section_contained_within_another <- function(first_elf_range, second_elf_range){
  if(all(first_elf_range %in% second_elf_range) | all(second_elf_range %in% first_elf_range)){
    return(TRUE)
  }
  return(FALSE)
}

# Function that takes in the first and second elf range
# Returns TRUE if any item in the first range is in the second or if any item in the second range is in the first
# Returns FALSE otherwise
section_overlapping_within_another <- function(first_elf_range, second_elf_range){
  if(any(first_elf_range %in% second_elf_range) | any(second_elf_range %in% first_elf_range)){
    return(TRUE)
  }
  return(FALSE)
}

puzzle_input <- puzzle_input %>% 
  dplyr::mutate(
    first_elf_range = sapply(puzzle_input$first_elf, section_to_range),
    second_elf_range = sapply(puzzle_input$second_elf, section_to_range),
    section_contained = mapply(section_contained_within_another, first_elf_range, second_elf_range),
    section_overlapping = mapply(section_overlapping_within_another, first_elf_range, second_elf_range)
  )

# Part 1 
print(paste("The number of assignment pairs where one range is fully contained within the other is", sum(puzzle_input_part1$section_contained)))
# Part 2
print(paste("The number of assignment pairs where one range is overlapping with the other is", sum(puzzle_input_part1$section_overlapping)))