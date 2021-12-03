using Printf

# helper: convert a string to an array of ints
function line_to_arr(line)
    return map(
           x -> parse(Int64, x),
           split(line, "")
    )
end

# convert all lines of the input to an array of column vectors
all_readings = map(x -> line_to_arr(x), readlines("input.txt"))

# create a matrix of 5xN from the readings by horizontal concatenation
all_readings = reduce(hcat, all_readings)
readings_width, readings_length = size(all_readings)

@printf("Readings shape: %s\n", size(all_readings))

# helper: find most common bit in array
function arr_to_gamma_bit(arr)
    if sum(arr) > (length(arr) / 2)
        return 1
    end
    return 0
end

# helper: convert binary array to number
function bin_arr_to_number(arr)
    # hack: we can zip against a reversed array to get indices to line up
    #       with powers of two
    arr = reverse(arr)

    # poor man's zip
    return sum([ (2^(n-1) * arr[n]) for n in 1:length(arr) ])
end

# calculate gamma, epsilon
gamma   = [arr_to_gamma_bit(all_readings[n,:]) for n in 1:readings_width]
epsilon = map(x -> 1 - x, gamma)

# conversions to number
gamma   = bin_arr_to_number(gamma)
epsilon = bin_arr_to_number(epsilon)

# show for posterity
@printf("Power consumption: %d\n", gamma * epsilon)
