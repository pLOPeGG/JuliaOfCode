function parseline(line)
    parse.(Int, split(line))
end

function iter_diff_end(xs)
    sav = Int[xs[end]]

    while any(!=(0), xs)
        xs = diff(xs)
        push!(sav, xs[end])
    end
    sav
end


function iter_diff_begin(xs)
    sav = Int[xs[begin]]

    while any(!=(0), xs)
        xs = diff(xs)
        push!(sav, xs[begin])
    end
    sav
end

function solve1(data)
    sum(data) do xs
        sum(iter_diff_end(xs))
    end
end

function solve2(data)
    sum(data) do xs
        sum(enumerate(iter_diff_begin(xs))) do (i, y)
            y * (3 - mod1(i, 2) * 2)
        end
    end
end

data = readlines() .|> parseline
data |> solve1 |> println
data |> solve2 |> println
