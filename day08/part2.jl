using Printf
using Combinatorics

all_readings = readlines("input.txt")

const DigitReading = Set{Char}

struct SegmentReading
    inputs::Vector{DigitReading}
    outputs::Vector{DigitReading}
end

#  Segment solution mapping
#
#        1111
#       2    3
#       2    3
#        4444
#       5    6
#       5    6
#        7777
const DisplayConfiguration = Dict{Char, Int} 

function parse_reading(line)::SegmentReading
    inputs, outputs = split(line, " | ")

    create_sets(str) = map(x -> Set(x), split(str, " "))

    return SegmentReading(
        create_sets(inputs),
        create_sets(outputs)
    )
end

valid_configs = Dict(
    0 => Set([1,2,3,5,6,7]),
    1 => Set([3,6]),
    2 => Set([1,3,4,5,7]),
    3 => Set([1,3,4,6,7]),
    4 => Set([2,3,4,6]),
    5 => Set([1,2,4,6,7]),
    6 => Set([1,2,4,5,6,7]),
    7 => Set([1,3,6]),
    8 => Set([1,2,3,4,5,6,7]),
    9 => Set([1,2,3,4,6,7])
)
function valid_for_digit(true_digit::Int64, reading::DigitReading, config::DisplayConfiguration)
    global valid_configs

    digit_cfg = valid_configs[true_digit]
    inferred = Set([ config[d] for d in reading])

    return issetequal(digit_cfg, inferred)
end

function perm_to_config(perm::Vector{Int64})::DisplayConfiguration
    return Dict(
        'a' => perm[1],
        'b' => perm[2],
        'c' => perm[3],
        'd' => perm[4],
        'e' => perm[5],
        'f' => perm[6],
        'g' => perm[7],
    )
end

function infer_configuration(reading::SegmentReading)::DisplayConfiguration
    easy_len_to_digit = Dict( 2 => 1, 4 => 4, 3 => 7, 7 => 8 )

    for perm in permutations(1:7)
        cfg = perm_to_config(perm)

        all_digits = vcat(reading.inputs, reading.outputs)
        all_easy   = [ digit for digit in all_digits if length(digit) in [2,4,3,7] ]

        flags = [  valid_for_digit( easy_len_to_digit[length(d)], d, cfg) for d in all_easy ]
        
        if all(flags)
            # check the rest of the digits
            flags_all = [ decode_digit( d, cfg ) for d in all_digits ]

            flags_all = map(x -> x != -1, flags_all)

            if all(flags_all)
                # valid config
                return cfg
            end
        end
    end
    println("Couldn't find configuration!")
end

function decode_digit(digit::DigitReading, config::DisplayConfiguration)
    global valid_configs

    decoded = Set([ config[d] for d in digit ])

    for i in 0:9
        if issetequal(decoded, valid_configs[i])
            return i
        end
    end

    return -1
end

function decode_reading(reading::SegmentReading, config::DisplayConfiguration)
    for inp in reading.inputs
        @printf("%s: %d\n", join(inp, ""), decode_digit(inp, config))
    end
    reading_out = 0
    for (i, out) in enumerate(reading.outputs)
        num = decode_digit(out, config)
        @printf("%s: %d\n", join(out, ""), num)

        reading_out += num * (10^(length(reading.outputs) - i))
    end

    return reading_out
end

function get_output(reading::SegmentReading)::Int64
    cfg = infer_configuration(reading)
    return decode_reading(reading, cfg)
end

example_config = Dict('a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5, 'f' => 6, 'g' => 7)
reading        = Set("cf")

@debug valid_for_digit(1, Set("cf"), example_config)
@debug valid_for_digit(2, Set("cf"), example_config)

all_readings = [ parse_reading(line) for line in all_readings ]

all_outputs = [ get_output(reading) for reading in all_readings ]

@debug all_outputs

@printf("Final sum: %d\n", sum(all_outputs))
# cfg = infer_configuration( all_readings[1] )

# # cfg = Dict('a' => 3, 'b' => 6, 'c' => 7, 'd' => 1, 'e' => 2, 'f' => 4, 'g' => 5)

# @debug decode_digit(all_readings[1].inputs[1], cfg)

# @debug decode_reading(all_readings[1], cfg)

# function count_easy(reading)
#     easy = [ 1 for set in reading.outputs if length(set) in [2,4,3,7] ]

#     return sum(easy)
# end

# @printf("easy digits: %d\n", sum([count_easy(r) for r in all_readings]))


