function parse_line(line)
    dims = parse.(Ref(Int), split(line, "x"))
    NamedTuple{(:l, :w, :h)}(dims)
end

const data = readlines() .|> parse_line 

function area(box)
    sides = (box.l*box.w, box.l*box.h, box.w*box.h)
    2 * sum(sides) + minimum(sides)
end

function solve_1()
    area.(data) |> sum
end

function len(box)
    perimeter = 2 * (sum(box) - maximum(box))
    perimeter + prod(box)
end

function solve_2()
    len.(data) |> sum
end

solve_1() |> println
solve_2() |> println