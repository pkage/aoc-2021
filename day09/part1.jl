using Printf

function parse_input(input_file)
    all_lines = readlines(input_file)
    
    line_to_col(l) = map(x -> parse(Int64, x), split(l, ""))

    mtx = reduce(hcat, map(line_to_col, all_lines))

    return transpose(mtx)
end

function add_matrix_bounds(mtx)
    horiz = ones((1, size(mtx, 2) + 2)) * Inf
    vert  = ones(size(mtx, 1)) * Inf

    @show size(horiz)
    @show size(vert)

    return vcat(
        horiz,
        hcat(vert, mtx, vert),
        horiz
    )
end

function identify_low(mtx)
    bounded = add_matrix_bounds(mtx)

    h, w = size(bounded)

    low_spots = []

    for y in 2:(h-1)
        for x in 2:(w-1)
            c = bounded[y,x]


            neighbors = [
                bounded[y+1,x], 
                bounded[y-1,x],
                bounded[y,x+1],
                bounded[y,x-1]
            ]

            # @printf("considering %d,%d (c: %d, n: %s)\n", y,x, c, join(neighbors, ","))
            
            if all(map(x -> c < x, neighbors))
                push!(low_spots, c)
            end
        end
    end

    return low_spots
end

mtx = parse_input("input.txt")

display(mtx)
println()

@show size(mtx)
low = identify_low(mtx)

@printf("Soln: %d\n", sum(low) + length(low))

