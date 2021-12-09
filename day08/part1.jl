using Printf

all_readings = readlines("input.txt")

struct SegmentReading
    inputs::Vector{Set{Char}}
    outputs::Vector{Set{Char}}
end

function parse_reading(line)::SegmentReading
    inputs, outputs = split(line, " | ")

    create_sets(str) = map(x -> Set(x), split(str, " "))

    return SegmentReading(
        create_sets(inputs),
        create_sets(outputs)
    )
end

all_readings = [ parse_reading(line) for line in all_readings ]

function count_easy(reading)
    easy = [ 1 for set in reading.outputs if length(set) in [2,4,3,7] ]

    return sum(easy)
end

@printf("easy digits: %d\n", sum([count_easy(r) for r in all_readings]))
