# Solution to Question 2

# 0th index is rock and gives 1 point, 1st index is paper and gives 2 points, 2nd index is scissors and gives 3 points
moves_scores_lookup = [1, 2, 3]

# 0th index is a draw and gives 3 points, 1st index is a loss and gives 0 points, 2nd index is a win and gives 6 points
outcome_scores_lookup = [3, 0, 6]

# Function takes in the opponents move and my move (which is either 0, 1,or 2) and returns the outcome score (for me)
def my_score(opponent_move, my_move):
    return outcome_scores_lookup[(opponent_move-my_move) % 3] + moves_scores_lookup[my_move]

# Take either the opponent or my move and return the 0,1 or 2 representation of that move
def string_to_integer_move(move):
    if move == 'A' or move == 'X':
        return 0
    elif move == 'B' or move == 'Y':
        return 1
    else:
        return 2

# Given the opponents move and the game outcome, this function returns the correct move that I should play to meet the outcome
def what_move_do_i_play(opponent_move, outcome):
    if outcome == "X":
        return (opponent_move + 2) % 3
    elif outcome == "Y":
        return opponent_move
    else:
        return (opponent_move+1) % 3


# Part 1

# Loop through each line, extract the opponents move and my move then total up the score for each game
with open('puzzle_input.txt') as puzzle_input:
    my_total_score_part1 = 0
    for line in puzzle_input:
        seperated_moves = line.split()
        opponent_move = string_to_integer_move(seperated_moves[0])
        my_move = string_to_integer_move(seperated_moves[1])
        my_total_score_part1 = my_total_score_part1 + my_score(opponent_move, my_move)
    print("My total score is {} (part 1)".format(my_total_score_part1))

# Part 2

# Loop through each line, extract the opponents move and game outcome. 
# Then calculate what move I should play according to the outcome then total up the score for each game
with open('puzzle_input.txt') as puzzle_input:
    my_total_score_part2 = 0
    for line in puzzle_input:
        seperated_moves = line.split()
        opponent_move = string_to_integer_move(seperated_moves[0])
        outcome = seperated_moves[1]
        my_move = what_move_do_i_play(opponent_move, outcome)
        my_total_score_part2 = my_total_score_part2 + my_score(opponent_move, my_move)
    print("My total score is {} (part 2)".format(my_total_score_part2))
