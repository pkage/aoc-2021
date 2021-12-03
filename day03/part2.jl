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
function arr_to_crit_bit(arr)
    if sum(arr) >= (length(arr) / 2)
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

# helper: drop columns from matrix
function drop_columns(mtx, cols)
    return mtx[1:end, 1:end .∉ [cols]]
end


function find_rating(mtx; mode="o2")
    for n in 1:readings_width
        criteria_bit = arr_to_crit_bit(mtx[n,:])
        if mode == "co2"
            criteria_bit = 1 - criteria_bit
        end
        columns = enumerate(mtx[n,:])
        # @show collect(columns)
        columns = filter(x -> x[2] != criteria_bit, collect(columns))
        columns = map(x -> x[1], columns)
        # @printf("Step %d: dropping %s\n", n, columns)
        # display(mtx)
        # println()
        mtx = drop_columns(mtx, columns)

        if size(mtx)[2] == 1
            break
        end
    end

    return mtx[:,1]
end

o2_mtx = find_rating(all_readings; mode="o2")
co2_mtx = find_rating(all_readings; mode="co2")

o2  = bin_arr_to_number( o2_mtx)
co2 = bin_arr_to_number(co2_mtx)

@printf("O2: %d, CO2: %d, soln: %d\n", o2, co2, o2*co2)

# show for posterity
