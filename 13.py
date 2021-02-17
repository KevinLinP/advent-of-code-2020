# DEBUG = False
DEBUG = True

with open('13.input') as file:
    lines = file.read().splitlines()

earliest = int(lines[0])

buses = lines[1].split(',')
buses = filter(lambda s: s != 'x', buses)
buses = map(lambda s: int(s), buses)

print earliest
print buses

min = earliest * 2
min_id = -1

for increment in buses:
    current_time = 0

    while current_time < earliest:
        current_time += increment

    if current_time < min:
        min = current_time
        min_id = increment

    if DEBUG:
        print("%d %d" % (increment, current_time))

print("min:%d earliest_id:%d" % (min, min_id))
print("%d * %d = %d" % (min_id, (min - earliest), min_id * (min - earliest)))

