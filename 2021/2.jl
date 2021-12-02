function parse_line(l)
    mv, i = split(l)
    mv, parse(Int, i)
end

const data = parse_line.(readlines())

function solve_1()
    pos, depth = 0, 0
    for (mv, i) in data
        if mv == "forward"
            pos += i
        elseif mv == "up"
            depth -= i
        else
            depth += i
        end
    end
    pos * depth
end

function solve_2()
    pos, depth, aim = 0, 0, 0
    for (mv, i) in data
        if mv == "forward"
            pos += i
            depth += aim * i
        elseif mv == "up"
            aim -= i
        else
            aim += i
        end
    end
    pos * depth
end

solve_1() |> println
solve_2() |> println