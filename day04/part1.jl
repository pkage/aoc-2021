using Printf

all_lines = readlines("input_ex.txt")

struct Board
    nums::Matrix{Int64}
end

function parse_board(arr::Vector{String})
    arr = map(
            x -> map(y -> parse(Int64, y), split(x, " ")),
            arr
    )

    return reduce(hcat, arr)
end

function write_number(board::Board, number::Int64)::Board

end

function check_win(board::Board)::Bool

end

function sum_unmarked(board::Board)::Int64

end

ex_board = [
    "22 13 17 11  0", 
    " 8  2 23  4 24",
    "21  9 14 16  7",
    " 6 10  3 18  5",
    " 1 12 20 15 19"
]

@debug parse_board(ex_board)
