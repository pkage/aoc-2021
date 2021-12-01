# read all lines into a vector
all_readings = map(l -> parse(Int64, l), readlines("input_ex.txt"))

windows = zeros(length(all_readings)-2)
for i in 1:(length(windows))
    windows[i] = all_readings[i] + all_readings[i+1] + all_readings[i+2]
end

println(windows)

# zip with itself, offset by one
# creates a list of tuples of (reading, previous_reading)
pairs = zip(windows[2:end], windows)

# get the increases
increases = filter(p -> p[1] > p[2], collect(pairs))

# print the length of the increases
println(length(increases))
