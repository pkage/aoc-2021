using Printf

line = readlines("input.txt")[1]

function parse_line(line)
    return map(x -> parse(Int64, x), split(line, ","))
end

function step(arr::Vector{Int64})::Vector{Int64}
    new_fish = 0
    
    for i in 1:length(arr)
        if arr[i] == 0
            arr[i] = 6
            new_fish += 1
        else
            arr[i] -= 1
        end
    end

    return vcat(arr, ones(new_fish) * 8)
end

function lifetime(arr::Vector{Int64}, max_gen)
    for gen in 1:max_gen
        arr = step(arr)
        # @printf("After %d generations: %s\n", gen, arr)
        @printf("After %d generations, there are %d fish\n", gen, length(arr))
    end

    @printf("After %d generations, there are %d fish\n", max_gen, length(arr))
end
lifetime(parse_line(line), 80)

