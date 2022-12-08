# Solution to Question 1

with open('puzzle_input.txt') as puzzle_input:
    # Store the total calories for every elf in an array
    total_calories_array = []
    # The total calories for one elf (temporary variable which stores the calories total per elf)
    total_calories = 0
    # Loop through the lines of the text file
    for line in puzzle_input:
        # If there is a line break then add the total_calories for the previous elf into the total_calories_array and reset total_calories to 0
        if len(line.strip()) == 0:
            total_calories_array.append(total_calories)
            total_calories = 0
        # If there is not line break then add the line (as an integer) to the total_calories
        else:
            total_calories = total_calories + int(line.strip())

# Sort the total_calories_array from highest to lowest
total_calories_array.sort(reverse=True)

print("The Elf carrying the most calories is carrying a total of {} calories".format(
    total_calories_array[0]))
print("The top three Elves are carrying a total of {} calories".format(
    total_calories_array[0] + total_calories_array[1] + total_calories_array[2]))
