# Solution to Question 3

library(dplyr)

# Read in the puzzle input file as a CSV
puzzle_input <- read.csv('puzzle_input.csv', header=FALSE)
colnames(puzzle_input) <- c("rucksack_contents")
# Change the rucksack_content column from a factor w/ levels to a character column
puzzle_input$rucksack_contents <- as.character(puzzle_input$rucksack_contents)

# For a given letter a-z or A-Z, this function returns the index of that letter
# i.e. calculate_priority_number('a') will return 1, calculate_priority_number('B') will return 28
calculate_priority_number <- function(priority_letter){
  priorities <- c(letters, LETTERS)
  return(match(priority_letter,priorities))
}

##########
# Part 1
##########

# This function will return the common item between the two compartments
# i.e. calculate_priority_letter('lvcNpRHD','CnTLCJlL') will return 'l'
calculate_priority_letter <- function(first_compartment, second_compartment) {
  first_compartment_split <- strsplit(first_compartment, "")
  second_compartment_split <- strsplit(second_compartment, "")
  common_item <- Reduce(intersect, c(first_compartment_split, second_compartment_split))
  return(common_item)
}

# Create new columns for the items in the first and second compartment, then new columns containing the priority letter and number
puzzle_input_part1 <- puzzle_input %>% 
  dplyr::mutate(first_compartment = substr(puzzle_input$rucksack_contents, 1, nchar(puzzle_input$rucksack_contents)/2), 
                second_compartment = substr(puzzle_input$rucksack_contents, nchar(puzzle_input$rucksack_contents)/2+1, nchar(puzzle_input$rucksack_contents)),
                priority_letter = mapply(calculate_priority_letter, first_compartment, second_compartment),
                priority_number = sapply(priority_letter, calculate_priority_number)
                )

print(paste("The sum of the priorities for items that appear in both compartments is", sum(puzzle_input_part1$priority_number)))

##########
# Part 2
##########

# Function takes in an elf group vector consisting of 3 elves
# Creates a vector called split_rucksack which splits each elves rucksack into letters
# Finds the common item (badge) between each elf
# Returns the priority number for the badge
calculate_priority_per_group <- function(elf_group){
  split_rucksack <- sapply(elf_group, strsplit, "")
  common_item <- Reduce(intersect, split_rucksack)
  priority <- calculate_priority_number(common_item)
  return(priority)
}

rucksack <- puzzle_input$rucksack_contents
# Split the elves into groups of 3 (not 100% sure how this line works)
elf_groups <- split(rucksack, ceiling(seq_along(rucksack)/3))
# For each group calculate their priority and store in the priorities vector
priorities <- sapply(elf_groups, calculate_priority_per_group)
print(paste("The sum of the priorities for badge items that appear in all elf groups is", sum(priorities)))
