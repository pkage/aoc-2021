using IterTools
using Printf

hpos = 0
vpos = 0

# read all lines into a vector
all_readings = readlines("input.txt")

for line in all_readings
    global hpos
    global vpos
    dir, amt = split(line, " ")
    amt = parse(Int64, amt)

    @printf("Going %s amount %d\n", dir, amt)
    
    if dir == "forward"
        hpos += amt
    elseif dir == "up"
        vpos -= amt
    elseif dir == "down"
        vpos += amt
    end

    @printf("Position: (%d, %d)\n", hpos, vpos)
end

println("FINAL\n\n")

@printf("Position: (%d, %d)\n", hpos, vpos)
@printf("Product: %d\n", hpos * vpos)

