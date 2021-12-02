using MLStyle

function parse_line(l)
    mv, i = split(l)
    mv, parse(Int, i)
end

const data = parse_line.(readlines())

function solve_1()
    pos, depth = 0, 0
    for (mv, i) in data
        pos, depth = @match (mv, i) begin
            ("forward", i) => (pos + i, depth)
            ("up", i) => (pos, depth - i)
            ("down", i) => (pos, depth + i)
        end
    end
    pos * depth
end

function solve_2()
    pos, depth, aim = 0, 0, 0
    for (mv, i) in data
        pos, depth, aim = @match (mv, i) begin
            ("forward", i) => (pos + i, depth + aim * i, aim)
            ("up", i) => (pos, depth, aim - i)
            ("down", i) => (pos, depth, aim + i)
        end
    end
    pos * depth
end

solve_1() |> println
solve_2() |> println