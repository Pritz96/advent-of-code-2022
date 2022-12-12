with open('puzzle_input.txt') as puzzle_input:
    instructions = [line.rstrip('\r\n') for line in puzzle_input]

# Takes in the x_values list and adds on one waiting cycle followed by the cycle where the value is added
def addx_instruction(x_values, instruction):
    return(x_values + [x_values[-1], x_values[-1] + int(instruction.split(" ")[1])])

# Takes in the x_values list and adds on one waiting cycle
def noop_instruction(x_values):
    return(x_values + [x_values[-1]])


x_values = [1]

for instruction in instructions:
    if(instruction == "noop"):
        x_values = noop_instruction(x_values)
    else:
        x_values = addx_instruction(x_values, instruction)

indeces = range(20, 240, 40)
signal_strength = [x * (x_values[x-1]) for x in indeces]
print("The sum of the signal strengths is {} (part 1)".format(sum(signal_strength)))


pixels = []
for i in range(0, len(x_values)-1):
    if i % 40 in [x_values[i]-1, x_values[i], x_values[i]+1]:
        pixels.append('#')
    else:
        pixels.append('.')

# Split the pixels list into multiple lists, each list contains 1 CRT row
list_of_crt_rows = [pixels[n:n+40] for n in range(0, len(pixels), 40)]
for crt_row in list_of_crt_rows:
    print((" ").join(crt_row))
