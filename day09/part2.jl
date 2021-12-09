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


function flow_down(mtx, point::Point) #, basins::Vector{Point})
    within_bounds(p) = p[1] > 0 && p[1] <= size(mtx, 1) && p[2] > 0 && p[2] <= size(mtx, 2)

    add_points(p1, p2) = (p1[1] + p2[1], p1[2] + p2[2])
    function get_next(point)
        candidates = [
            add_points(point, ( 1, 0)),
            add_points(point, (-1, 0)),
            add_points(point, ( 0, 1)),
            add_points(point, ( 0,-1))
        ]

        original_val = mtx[point...]

        for c in candidates
            if !within_bounds(c)
                continue
            end
            if mtx[c...] < original_val
                return c
            end
        end

        return point
    end
    
    if mtx[point...] == 9
        return nothing
    end

    last = point
    while true
        next = get_next(last)
        if next == last
            return next
        end
        last = next
    end
end

function flow_all(mtx)
    sinks = Dict()

    low_points = identify_low(mtx)
    
    for p in low_points
        sinks[p] = 0
    end

    basin_map = zeros(size(mtx))

    for y in 1:size(mtx, 1)
        for x in 1:size(mtx, 2)
            @printf("searching %d, %d\n", y,x)
            basin = flow_down(mtx, (y,x))

            if basin != nothing
                @printf("\tflowed to %s\n", basin)
                basin_map[y, x] = findall(z -> z == basin, low_points)[1]
                sinks[basin] += 1
            end
        end
    end

    println(sinks)

    return (basin_map, sinks)
end

mtx = parse_input("input.txt")

display(mtx)
println()

@show size(mtx)
@show identify_low(mtx)

basin_map, sinks = flow_all(mtx)
display(basin_map)
println()

largest = reverse(sort([v for (k,v) in sinks]))[1:3]

println(largest)
println(reduce(*, largest))


