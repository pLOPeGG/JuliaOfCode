function parse_line(l)
    m = match(r"(?<action>turn on|turn off|toggle) (?<x_b>\d+),(?<y_b>\d+) through (?<x_e>\d+),(?<y_e>\d+)", l)
    for symb in (:x_b, :y_b, :x_e, :y_e)
        @eval $symb = parse(Int, $(m[symb])) + 1
    end
    (;action=m[:action], x_b, y_b, x_e, y_e)
end

data = readlines() .|> parse_line

function solve_1()
    m = falses(1000, 1000)
    for t in data
        x_range = t[:x_b]:t[:x_e]
        y_range = t[:y_b]:t[:y_e]
        if t[:action] == "turn on"
            m[x_range, y_range] .= true
        elseif t[:action] == "turn off"
            m[x_range, y_range] .= false
        else
            m[x_range, y_range] .= .!m[x_range, y_range]
        end
    end
    count(m)
end

function solve_2()
    m = zeros(BigInt, 1000, 1000)
    for t in data
        x_range = t[:x_b]:t[:x_e]
        y_range = t[:y_b]:t[:y_e]
        if t[:action] == "turn on"
            m[x_range, y_range] .+= 1
        elseif t[:action] == "turn off"
            m[x_range, y_range] .-= 1
            m[x_range, y_range] .= max.(0, m[x_range, y_range])
        else
            m[x_range, y_range] .+= 2
        end
    end
    sum(m)
end

solve_1() |> println
solve_2() |> println