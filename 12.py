debug = False
# debug = True
direction = 1
x = 0
y = 0

with open('12.input') as file:
    for line in file:
        op = line[0]
        arg = int(line[1:-1])

        # now with 100% more maps
        if op in ['L', 'R']:
            divisor = {'L': -90, 'R': 90}[op]

            direction += (arg / divisor)
            direction %= 4
        else:
            move_direction = {
                'F': direction,
                'N': 0,
                'E': 1,
                'S': 2,
                'W': 3
            }[op]

            vec = {
                0: (0, 1),
                1: (1, 0),
                2: (0, -1),
                3: (-1, 0)
            }[move_direction]

            x += vec[0] * arg
            y += vec[1] * arg

        if debug:
            print('%d %d' % (x, y))

if debug:
    print('')
print('%d %d' % (x, y))
print('%d' % (abs(x) + abs(y)))
