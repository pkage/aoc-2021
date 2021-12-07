using LinearAlgebra
using Printf

all_lines = readlines("input.txt")

const Board = Matrix{Int64}

function parse_board(arr::String)::Board
    arr = split(strip(arr), "\n")
    local out::Vector{Vector{Int64}} = []
    for row in arr
        strs = collect(split(strip(row), r"\W+"))
        push!(out, collect(map(x -> parse(Int64, x), strs)))
    end

    return reduce(hcat, out)
end

function write_number(board::Board, number::Int64)::Board
    return replace(board, number => -1)
end

function check_win(board::Board)::Bool
    all_win(vec) = all(vec)

    flags = map(x -> x == -1, board)

    # check rows and cols simultaneously
    for idx in 1:5
        if all(flags[idx,:])
            # row win
            println("row win!")
            return true
        end

        if all(flags[:,idx])
            println("col win!")
            return true
        end
    end

    #= diagonal wins
    if all(diag(flags))
        println("diag win!")
        return true
    end

    if all(diag(flags[:,end:-1:1]))
        println("reverse diag win!")
        return true
    end =#
    return false
end

function sum_unmarked(board::Board)::Int64
    # remove flags
    b2 = replace(board, -1 => 0)

    return sum(b2)
end

function parse_input(lines::Vector{String})::Tuple{Vector{Int64}, Vector{Board}}
    numbers = map(x -> parse(Int64, x), split(lines[1], ","))

    boards_str = split(join(lines[2:end], "\n"), "\n\n")

    return (numbers, [parse_board(string(b)) for b in boards_str])
end

function play_game(lines::Vector{String})
    numbers, boards = parse_input(lines)

    already_won = Set([])

    for num in numbers
        println("Calling ", num)
        boards = map(b -> write_number(b, num), boards)
        display(reduce(hcat, boards))
        println()

        for b_idx in 1:length(boards)
            b = boards[b_idx]
            if check_win(b)
                push!(already_won, b_idx)

                if length(already_won) == length(boards)
                    println("Win detected!")
                    display(b)
                    println()

                    @printf("Last board standing: %d\n", b_idx)
                    @printf("Remaining sum: %d\n", sum_unmarked(b))
                    @printf("Final score: %d\n", sum_unmarked(b) * num )
                
                    return
                end
            end
        end
    end
end

play_game(all_lines)

#=
ex_board = join([
    "22 13 17 11  0", 
    " 8  2 23  4 24",
    "21  9 14 16  7",
    " 6 10  3 18  5",
    " 1 12 20 15 19"
], "\n")

# @debug parse_board(ex_board)
display(parse_board(ex_board))
println()

b = parse_board(ex_board)
for num in [1,10,14,4,0]
    global b
    b = write_number(b, num)
end
display(b)
println()

if check_win(b)
    print("Sum: ")
    println(sum_unmarked(b))
end

@debug parse_input(all_lines)
=#
