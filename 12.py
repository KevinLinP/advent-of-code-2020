DEBUG = False
# DEBUG = True

ROTATIONS = {
    0: 0,
    90: 1,
    180: 2,
    270: 3,
}

MOVE_DIRECTIONS = {
    'F': None,
    'N': 0,
    'E': 1,
    'S': 2,
    'W': 3
}

MOVE_VECTORS = {
    0: (0, 1),
    1: (1, 0),
    2: (0, -1),
    3: (-1, 0)
}

direction = 1
x = 0
y = 0

with open('12.input') as file:
    for line in file:
        op = line[0]
        arg = int(line[1:-1])

        # now with 100% more maps
        if op in ['L', 'R']:
            rotation = ROTATIONS[arg]

            if op == 'R':
                direction += rotation
            else:
                direction -= rotation

            direction %= 4
        else:
            move_direction = MOVE_DIRECTIONS[op]
            if move_direction == None:
                move_direction = direction
            vec = MOVE_VECTORS[move_direction]

            x += vec[0] * arg
            y += vec[1] * arg

        if DEBUG:
            print('%d %d' % (x, y))

if DEBUG:
    print('')
print('%d %d' % (x, y))
print('%d' % (abs(x) + abs(y)))
