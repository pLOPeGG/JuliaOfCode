using MLStyle

function parse_line(l)
    mv, i = split(l)
    mv, parse(Int, i)
end

const data = parse_line.(readlines())

function solve_1()
    pos, depth = 0, 0
    for (mv, i) in data
        @match (mv, i) begin
            ("forward", i) => (pos += i)
            ("up", i) => (depth -= i)
            ("down", i) => (depth += i)
        end
    end
    pos * depth
end

function solve_2()
    pos, depth, aim = 0, 0, 0
    for (mv, i) in data
        @match (mv, i) begin
            ("forward", i) => (pos += i; depth += aim * i)
            ("up", i) => (aim -= i)
            ("down", i) => (aim += i)
        end
    end
    pos * depth
end

solve_1() |> println
solve_2() |> println