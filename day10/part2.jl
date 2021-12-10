using DataStructures
using Statistics
using Printf

all_lines = readlines("input.txt")

matches = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)

syntax_scores = Dict(
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
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
                return nothing
            end
        end
    end

    if !isempty(stack)
        score = 0
        print("\tcompletion: ")
        for c in stack
            score *= 5
            score += syntax_scores[matches[c]]
            print(matches[c])
        end
        @printf(" worth %d\n", score)

        return score
    end
end

function sum_scores(lines)
    scores = []

    for line in lines
        println(line)
        @printf("\t")
        c = check_line(line)
        if c != nothing
            push!(scores, c)
        end
    end

    return floor(Int64, median(scores))
end


@show sum_scores(all_lines)
