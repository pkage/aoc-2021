# read all lines into a vector
all_readings = map(l -> parse(Int64, l), readlines("input.txt"))

# zip with itself, offset by one
# creates a list of tuples of (reading, previous_reading)
pairs = zip(all_readings[2:end], all_readings)

# get the increases
increases = filter(p -> p[1] > p[2], collect(pairs))

# print the length of the increases
println(length(increases))
