# Solution to Question 8

library(data.table)

# Read in the puzzle input and split on each character
puzzle_input <- lapply(readLines("puzzle_input.txt"), function(line){return(as.integer(unlist(strsplit(line, ""))))})
# Convert to a dataframe
puzzle_input <- as.data.frame(puzzle_input)
# Transpose dataframe to look like the puzzle input
puzzle_input <- transpose(puzzle_input)

# Function takes in a single tree height and a vector containing the nearby tree heights
# Returns TRUE if the single tree height is greater than ALL of the nearby tree heights
is_tree_visible <- function(single_tree_height, nearby_tree_heights){
  is_tree_visible_vector <- sapply(nearby_tree_heights, function(nearby_tree){
    return(single_tree_height > nearby_tree)
  })
  return(all(is_tree_visible_vector))
}

# Function takes in a line of tree's and returns a new line containing logical values
# TRUE in a position if that tree is visible, FALSE otherwise
is_tree_line_visible <- function(tree_line){
  is_visible <- lapply(seq_along(tree_line), function(tree_index){
    if(tree_index == 1){
      return(TRUE)
    }
    nearby_trees <- tree_line[1:(tree_index-1)]
    return(is_tree_visible(tree_line[tree_index], nearby_trees))
  })
  return(is_visible)
}
# For each direction we create a matrix containing logical values
# TRUE if the tree is visible in that direction, FALSE otherwise

# Start from top down position, we don't need to modify puzzle_input since it is already in a column format
up <- sapply(puzzle_input, is_tree_line_visible)

# To start from the bottom up we can simply reverse the order of the rows and apply the same function as before
# We then reverse back the result
down <- sapply(puzzle_input[order(nrow(puzzle_input):1),], is_tree_line_visible)
down <- down[order(nrow(down):1),]

# To start from the left we transpose the puzzle input to simulate starting from the left
# Again we have to re-transpose the result back
left <- sapply(transpose(puzzle_input), is_tree_line_visible)
left <- t(left)

# To start from right we have to both transpose and reverse the order of the rows
# Once we get our result, we transform the result back to the original shape
right <- transpose(puzzle_input)
right <- right[order(nrow(right):1),]
right <- sapply(right, is_tree_line_visible)
right <- right[order(nrow(right):1),]
right <- t(right)

# Create a new matrix where each cell contains the 'OR' result between the up,down,left,right logical matrices
final_matrix <- matrix(nrow=nrow(up),ncol=ncol(up))
for(row in 1:nrow(up)) {
  for(col in 1:ncol(up)) {
    final_matrix[row,col] <- up[[row,col]] | down[[row,col]] | left[[row,col]] | right[[row,col]]
  }
}
# Sum the number of TRUE (tree is visible) elements in the final matrix
print(paste(sum(final_matrix), "trees are visible from outside the grid"))

## Part 2

# Function takes in a single tree height and vector containing nearby tree heights
# Then returns the scenic score for that tree
scenic_score <- function(tree_height, nearby_trees_height){
  score <- 0 
  for (x in nearby_trees_height) {
    if(tree_height > x){
      score <- score + 1
    }
    else{
      score <- score + 1
      break
    }
  }
  return(score)
}

# Function takes in a line of tree's and returns a new line containing each tree's scenic score
calculate_tree_line_score <- function(line){
  scenic_score <- lapply(seq_along(line), function(item_index){
    # The first item is an edge so has a score of 0
    if(item_index == 1){
      return(0)
    }
    # Find nearby tree's but reverse the list of nearby trees to get the closest tree at the start of the list
    nearby_trees <- rev(line[1:(item_index-1)])
    return(scenic_score(line[item_index], nearby_trees))
  })
  return(scenic_score)
}

up <- sapply(puzzle_input, calculate_tree_line_score)

down <- sapply(puzzle_input[order(nrow(puzzle_input):1),], calculate_tree_line_score)
down <- down[order(nrow(down):1),]

left <- sapply(transpose(puzzle_input), calculate_tree_line_score)
left <- t(left)

right <- transpose(puzzle_input)
right <- right[order(nrow(right):1),]
right <- sapply(right, calculate_tree_line_score)
right <- right[order(nrow(right):1),]
right <- t(right)

final_matrix <- matrix(nrow=nrow(up),ncol=ncol(up))
for(row in 1:nrow(up)) {
  for(col in 1:ncol(up)) {
    final_matrix[row,col] <- up[[row,col]] * down[[row,col]] * left[[row,col]] * right[[row,col]]
  }
}
print(paste("The highest scenic score possible for any tree is", max(final_matrix)))
