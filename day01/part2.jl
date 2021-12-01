using IterTools

# read all lines into a vector
all_readings = map(l -> parse(Int64, l), readlines("input.txt"))

# mmm lovely partitioning with steps
windows = partition(all_readings, 3, 1)
windows = [sum(w) for w in windows]

# zip with itself, offset by one
# creates a list of tuples of (reading, previous_reading)
pairs = zip(windows[2:end], windows)

# get the increases
increases = filter(p -> p[1] > p[2], collect(pairs))

# print the length of the increases
println(length(increases))

