using Printf
using Statistics

line = readlines("input.txt")[1]

function parse_line(line)
    return map(x -> parse(Int64, x), split(line, ","))
end

function find_min_cost_position(arr)
    find_pos(x) = sum(map(y -> abs(x - y), arr))

    least_fuel = Inf
    least_pos  = Inf
    for pos in minimum(arr):maximum(arr)
        fuel = find_pos(pos)
        if fuel < least_fuel
            least_pos = pos
            least_fuel = fuel
        end
    end

    @printf("least cost position is %d with cost %d\n", least_pos, least_fuel)
end

find_min_cost_position(parse_line(line))
