using Printf

# we could do something clever... or we could just model the number of fish in each
# stage of the lifecycle

line = readlines("input.txt")[1]

function parse_line(line)
    raw_fish = map(x -> parse(Int64, x), split(line, ","))
    fish = zeros(Int64, 9)
    for r in raw_fish
        fish[r] += 1
    end

    return fish
end

function step(arr::Vector{Int64})::Vector{Int64}
    g_fish = arr[1]

    new_arr = vcat(arr[2:end], [g_fish])
    new_arr[7] += g_fish

    return new_arr
end

function lifetime(arr::Vector{Int64}, max_gen)
    for gen in 1:(max_gen-1)
        arr = step(arr)
        @printf("After %d generations: %s\n", gen, sum(arr))
        # @printf("After %d generations, there are %d fish\n", gen, length(arr))
    end

    @printf("After %d generations, there are %d fish\n", max_gen, sum(arr))
end

lifetime(parse_line(line), 256)

