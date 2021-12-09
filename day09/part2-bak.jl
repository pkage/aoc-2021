using Printf

const Point = Tuple{Int64, Int64}

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

function identify_low(mtx)::Vector{Point}
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
                push!(low_spots, (y-1,x-1))
            end
        end
    end

    return low_spots
end


function get_basin(mtx, root::Point)
    basin = []
    next  = [root]
    not_in_basin = []

    within_bounds(p) = p[1] > 0 && p[1] <= size(mtx, 1) && p[2] > 0 && p[1] <= size(mtx, 2)

    add_points(p1, p2) = (p1[1] + p2[1], p1[2] + p2[2])

    function get_neighbors(p, basin, not_in_basin)
        candidates = [
            add_points(p, ( 1, 0)),
            add_points(p, (-1, 0)),
            add_points(p, ( 0, 1)),
            add_points(p, ( 0,-1))
        ]

        valid(y) = within_bounds(y) && !in(y, basin) && !in(y, not_in_basin)

        return collect(
            filter(x -> valid(x), candidates)
        )
    end

    while true
        if length(next) == 0
            break
        end

        # pop the next point
        p = next[1]
        next = next[2:end]

        if 
    end

end

mtx = parse_input("input_ex.txt")

display(mtx)
println()

@show size(mtx)
low_points = identify_low(mtx)

@printf("Soln: %s\n", low_points)

