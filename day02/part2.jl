using IterTools
using Printf

hpos = 0
vpos = 0
aim  = 0

# read all lines into a vector
all_readings = readlines("input.txt")

for line in all_readings
    global aim
    global hpos
    global vpos
    dir, amt = split(line, " ")
    amt = parse(Int64, amt)

    @printf("Going %s amount %d\n", dir, amt)
    
    if dir == "forward"
        hpos += amt
        vpos += aim * amt
    elseif dir == "up"
        # vpos -= amt
        aim  -= amt
    elseif dir == "down"
        # vpos += amt
        aim  += amt
    end

    @printf("Position: (%d, %d)\n", hpos, vpos)
    @printf("Aim: %d\n", aim)
end

println("FINAL\n\n")

@printf("Position: (%d, %d)\n", hpos, vpos)
@printf("Aim: %d\n", aim)
@printf("Product: %d\n", hpos * vpos)

