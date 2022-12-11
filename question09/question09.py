import math

# Function takes in a coordinate, a direction and number of moves and returns a list of coordinates
# e.g. new_chain_of_coordinates([0,0], "R", 4)= [[1, 0], [2, 0], [3, 0], [4, 0]]
def new_chain_of_coordinates(last_coordinate, direction, number_of_moves):

    last_x_coordinate = last_coordinate[0]
    last_y_coordinate = last_coordinate[1]

    if(direction == "U"):
        return([[last_x_coordinate, (last_y_coordinate + i)] for i in range(1, number_of_moves+1)])
    elif(direction == "D"):
        return([[last_x_coordinate, (last_y_coordinate - i)] for i in range(1, number_of_moves+1)])
    elif(direction == "L"):
        return([[(last_x_coordinate-i), last_y_coordinate] for i in range(1, number_of_moves+1)])
    elif(direction == "R"):
        return([[(last_x_coordinate+i), last_y_coordinate] for i in range(1, number_of_moves+1)])
    else:
        return(last_coordinate)

# Function takes in the tails current position and heads next position and returns the new position that the tail should move to
def tails_next_position(tail_current_position, head_next_position):

    head_x = head_next_position[0]
    head_y = head_next_position[1]
    tail_x = tail_current_position[0]
    tail_y = tail_current_position[1]

    # If the head and tail are touching then return the tails current position since it does not need to move
    if points_touching(head_next_position, tail_current_position) == True:
        return(tail_current_position)

    # Head and tail on same horizontal
    if((tail_y == head_y) & (abs(head_x - tail_x) == 2)):
        if(head_x > tail_x):
            return([tail_x + 1, tail_y])

        if(head_x < tail_x):
            return([tail_x - 1, tail_y])

    # Head and tail on same vertical
    if((tail_x == head_x) & (abs(head_y - tail_y) == 2)):
        if(head_y > tail_y):
            return([tail_x, tail_y+1])

        if(head_y < tail_y):
            return([tail_x, tail_y-1])

    # Head and tail on diagonals
    if((head_x > tail_x) & (head_y > tail_y)):
        return([tail_x+1, tail_y+1])

    if((head_x < tail_x) & (head_y < tail_y)):
        return([tail_x-1, tail_y-1])

    if((head_x < tail_x) & (head_y > tail_y)):
        return([tail_x-1, tail_y+1])

    if((head_x > tail_x) & (head_y < tail_y)):
        return([tail_x+1, tail_y-1])

    return(tail_current_position)

# Function takes in a head coordinate and a tail coordinate and returns True if they are 'touching', False otherwise
def points_touching(head_coordinate, tail_coordinate):
    head_x = head_coordinate[0]
    head_y = head_coordinate[1]
    tail_x = tail_coordinate[0]
    tail_y = tail_coordinate[1]
    distance = math.sqrt(
        pow((head_x-tail_x), 2) + pow((head_y-tail_y), 2))
    if distance <= math.sqrt(2):
        return True
    return False

# Generic function that takes in a list of items, then returns the length of that list without duplicates
def length_of_deduplicated_list(list_with_duplicates):
    list_without_duplicates = []
    for x in list_with_duplicates:
        if x not in list_without_duplicates:
            list_without_duplicates.append(x)
    return(len(list_without_duplicates))

# Function that generates the next knot path given the previous knot path
# I.e. Given the head knot path (which is a list of coordinates) we can determine the path of the next knot using this function
def next_knot_path(last_knot_path):
    next_knot_coordinates_list = [[0, 0]]
    for h in range(1, len(last_knot_path)):
        next_knot_coordinates_list.append(tails_next_position(
            next_knot_coordinates_list[-1], last_knot_path[h]))
    return(next_knot_coordinates_list)

# Given the head path is already determined this function creates the paths for as many knots as you wish
# I.e. In Part 1, there are only 2 knots, so we first calculate the head knot path then we can run this function with number_of_total_knots=2 since in Part 1 there are a total of 2 knots (the Head and the Tail)
# I.e. In Part 2, there are only 10 knots, so we first calculate the head knot path then we can run this function with number_of_total_knots=10
# The 0th index of knot_paths is the head_knot_path followed by the paths of each following knot
def list_of_knot_paths(head_knot_path, number_of_total_knots):
    knot_paths = [head_knot_path]
    for x in range(1, number_of_total_knots):
        knot_paths.insert(x, next_knot_path(knot_paths[x-1]))
    return(knot_paths)

# Function that gets the tail path from a list of knot paths then returns the number of unique positions
def unique_positions_of_tail(list_of_knot_paths):
    return(length_of_deduplicated_list(list_of_knot_paths[-1]))


# Open the puzzle_input file, create a list of moves e.g. [[R,4], [U,8], ...]
with open('puzzle_input.txt') as puzzle_input:
    moves = [[line.rstrip('\r\n').split(" ")[0], int(
        line.rstrip('\r\n').split(" ")[1])] for line in puzzle_input]

# Define the initial coordinate of the head knot
head_knot_path = [[0, 0]]
# Loop through the moves that the head knot takes to create a path (list) of coordinates that the head takes
for move in moves:
    head_knot_path += new_chain_of_coordinates(
        head_knot_path[-1], move[0], move[1])

print("The tail of the rope visits {} positions at least once (part 1)".format(
    unique_positions_of_tail(list_of_knot_paths(head_knot_path, 2))))
print("The tail of the rope visits {} positions at least once (part 2)".format(
    unique_positions_of_tail(list_of_knot_paths(head_knot_path, 10))))
