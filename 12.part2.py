# DEBUG = False
DEBUG = True

ROTATIONS = {
    0: 0,
    90: 1,
    180: 2,
    270: 3,
}

waypoint_x = 10
waypoint_y = 1

pos_x = 0
pos_y = 0

with open('12.input') as file:
    for line in file:
        op = line[0]
        arg = int(line[1:-1])

        if op == 'N':
            waypoint_y += arg
        elif op == 'S':
            waypoint_y -= arg
        elif op == 'E':
            waypoint_x += arg
        elif op == 'W':
            waypoint_x -= arg
        elif op in ['L', 'R']:
            rotations = ROTATIONS[arg]
            if op == 'L':
                rotations = 4 - rotations

            # yes, it would be faster if i worked
            # out the transforms better
            for r in range(rotations):
                # 90 degree clockwise rotation
                temp_y = waypoint_y
                waypoint_y = -1 * waypoint_x
                waypoint_x = temp_y
        else:
            for i in range(arg):
                pos_x += waypoint_x
                pos_y += waypoint_y

        if DEBUG:
            print('%s waypoint: %d %d pos: %d %d' % (line, waypoint_x, waypoint_y, pos_x, pos_y))

if DEBUG:
    print('')
print('waypoint: %d %d pos: %d %d' % (waypoint_x, waypoint_y, pos_x, pos_y))
print('%d' % (abs(pos_x) + abs(pos_y)))
