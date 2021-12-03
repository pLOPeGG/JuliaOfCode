using Combinatorics

function parse_line(l)
    name, cap, dur, fla, tex, cal = match(r"(\w+)[^-\d]*(-?\d+)[^-\d]*(-?\d+)[^-\d]*(-?\d+)[^-\d]*(-?\d)[^-\d]*(\d+)", l).captures
    parse.(Int, (cap, dur, fla, tex, cal)) |> collect
end

const data = parse_line.(readlines())

function score(partition; d=data)
    m = reduce(hcat, d)
    maximum(permutations(partition)) do p
        max.(m * p, 0)[1:4] |> prod
    end
end

# Part 1
partitions(big(100), length(data)) .|> score |> maximum |> println

function score2(partition; d=data)
    m = reduce(hcat, d)
    maximum(permutations(partition)) do p
        v = max.(m * p, 0)
        v[end] <= 500 ? prod(v[1:end-1]) : -1
    end
end

# Part 2
partitions(big(100), length(data)) .|> score2 |> maximum |> println