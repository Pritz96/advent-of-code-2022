# Solution to Question 7

library(data.tree)

# Read in the puzzle input and split each line by a single space
puzzle_input <- lapply(readLines("puzzle_input.txt"), function(line){return(unlist(strsplit(line, " ")))})

# Create root_node
root_node <- Node$new("rootnode", type="folder", size=0)
# Set the current node to be the initial tree node
current_node <- root_node

# Loop through the commands in the puzzle and create the tree accordingly
for(command in puzzle_input[2:length(puzzle_input)]){
  
  # Ignore "$ ls" commands
  if(command[1] == "$" && command[2] == "ls"){
    next
  }
  
  # If current_node contains a directory then make the directory as a child of the current node
  if(command[1]=="dir"){
    current_node$AddChild(command[2], type="folder", size=0)
    next
  }
  
   # For '$ cd' commands, if '$ cd /' then navigate back to root_node, otherwise navigate to the sub-folder
   if(command[1]=="$" && command[2]=="cd"){
     if(command[3] == "/"){
       current_node <- root_node
     } else{
       current_node <- Navigate(current_node, command[3])
     }
     next
   }
  
  # If the command doesn't start with a '$' or 'dir' then make the file as a child of the current node
  if(command[1] != "$" || command[1] != "dir"){
    current_node$AddChild(command[2], type="file", size=command[1])
    next
  }
}

# Cast the 'size' attribute of each node to be numeric
root_node$Do(function(node) node$size <- as.numeric(node$size))

# Function on each node that returns the node size if the node is a leaf
# If the node is not a leaf, then sum the node's size and it's children's 'folder_size' attribute
aggregate_folder_size <- function(node) {
  if(node$isLeaf){
    return(node$size)
  }
  return(sum(Get(node$children, "folder_size")) + node$size)
}

# Recursively run the aggregate_folder_size function on every node
root_node$Do(function(node){
  node$folder_size <- aggregate_folder_size(node)
  }, traversal = "post-order")

# Print the tree
print(root_node,"type", "size", "folder_size")

## Part 1
# Filter the root_node tree to get just 'folder' nodes along with their 'folder_size'
folder_sizes <- root_node$Get('folder_size', filterFun = function(node){ node$type == "folder" })
# For Part 1 of this question we want folders with a total size of at most 100000
part1_folders <- folder_sizes[folder_sizes <= 100000]
print(paste("The sum of the total sizes of directories with a total size of at most 100000 is", sum(part1_folders)))

### Part2
unused_space <- (70000000 - root_node$folder_size)
# Calculate the minimum size of folder that needs to be deleted
min_directory_size <- (30000000 - unused_space)
# Filter folders that have a size over or including 'min_directory_size' 
part2_folders <- folder_sizes[folder_sizes >= min_directory_size]
# Find the smallest sized directory to delete
smallest_directory_size_to_delete <- min(part2_folders)
print(paste("The total size of the directory that, if deleted, would free up enough space on the filesystem to run the update is", sum(smallest_directory_size_to_delete)))