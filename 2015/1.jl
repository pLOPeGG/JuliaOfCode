data = readline()


function solve_1()
    count(==('('), data) - count(==(')'), data)
end

function solve_2()
    pos = 0
    for (i, c) in enumerate(data)
        pos += c == '(' ? 1 : -1
        if pos == -1
            return i
        end
    end
end

solve_1() |> println
solve_2() |> println