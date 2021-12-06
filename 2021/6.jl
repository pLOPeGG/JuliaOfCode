using Memoize

const data = parse.(Int, split(readline(), ","))

@memoize function count_production(timer, remaining)
    n = 1
    while remaining >= 0
        remaining -= timer+1
        if remaining >= 0
            n += count_production(8, remaining)
            timer = 6
        end
    end
    n
end

# Part One and Two
count_production.(data, 256) |> sum |> println