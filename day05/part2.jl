using Printf
using Base.Iterators

all_lines = readlines("input.txt")

const Point = Tuple{Int64,Int64}
const Line  = Tuple{Point, Point}
const Board = Matrix{Int64}

function parse_line(str)::Line
    p_start, p_end = split(str, " -> ")

    make_point(pstr) = Tuple(map(x -> parse(Int64, x) + 1, split(pstr, ",")))

    return (make_point(p_start), make_point(p_end))
end

function line_to_board(line::Line, max_size::Tuple{Int64, Int64})
    mtx = zeros((1000,1000))
    

    line_xs = (line[1][1], line[2][1])
    line_ys = (line[1][2], line[2][2])

    if line[1][1] == line[2][1] || line[1][2] == line[2][2]
        for x in minimum(line_xs):maximum(line_xs)
            for y in minimum(line_ys):maximum(line_ys)
                mtx[y, x] = 1
            end
        end
    else
        xd = line_xs[1] > line_xs[2] ? -1 : 1
        yd = line_ys[1] > line_ys[2] ? -1 : 1

        for (x,y) in zip(line_xs[1]:xd:line_xs[2], line_ys[1]:yd:line_ys[2])
            mtx[y, x] = 1
        end
    end

    return mtx
end

function parse_file(lines)::Tuple{Vector{Board}, Tuple{Int64, Int64}}
    lines = map(parse_line, lines)

    # collect only straight lines

    flattened_points = collect(flatten(lines))

    
    max_x = maximum(map(p -> p[1], flattened_points))
    min_x = minimum(map(p -> p[1], flattened_points))
    max_y = maximum(map(p -> p[2], flattened_points))
    min_y = minimum(map(p -> p[2], flattened_points))

    @printf("x: [%d, %d], y: [%d, %d]\n", min_x, max_x, min_y, max_y)

    boards = map(l -> line_to_board(l, (max_x, max_y)), lines)

    return (boards, (max_x, max_y))
end


# @debug collect(Iterators.flatten(parse_line("2,2 -> 2,1")))
# @debug parse_file(all_lines)

boards, _ = parse_file(all_lines)
board = reduce(+, boards)
overlaps = map(x -> x > 1 ? 1 : 0, board)
@printf("Overlaps: %d\n", sum(overlaps))


