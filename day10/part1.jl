using DataStructures
using Printf

all_lines = readlines("input.txt")

matches = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)

syntax_scores = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)

function check_line(line)
    stack = Stack{Char}()

    for i in 1:length(line)
        c = line[i]

        if in(c, ['(', '<', '[', '{'])
            push!(stack, c)
        else
            # get the opening character
            o = first(stack)
            
            # get the inverse
            o = matches[o]

            if c == o
                pop!(stack)
            else
                @printf("Expected '%s', found '%s' at position %d\n", o, c, i)
                return c
            end
        end
    end

    if !isempty(stack)
        println("No errors found, but line incomplete")
    end
end

function sum_scores(lines)
    illegals = []

    for line in lines
        println(line)
        @printf("\t")
        c = check_line(line)
        if c != nothing
            push!(illegals, syntax_scores[c])
        end
    end

    return sum(illegals)
end


@show sum_scores(all_lines)
