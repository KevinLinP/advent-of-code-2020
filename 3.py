# probably my language of choice for puzzling if
# execution speed wasn't a factor

file = open("3.input", "r")
PATTERN_WIDTH = 31

tree_counts = [0, 0, 0, 0, 0]

x_positions = [0, 0, 0, 0, 0]
slopes = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2],
]

for line_index, line in enumerate(file):
    for slope_index, slope in enumerate(slopes):
        slope = slopes[slope_index]

        if (line_index % slope[1]) != 0:
            continue

        x_pos = x_positions[slope_index]
        if line[x_pos] == "#":
            tree_counts[slope_index] += 1

        x_positions[slope_index] = (x_pos + slope[0]) % PATTERN_WIDTH

file.close

print(tree_counts)

product = reduce(lambda a, b: a * b, tree_counts)
print(product)
