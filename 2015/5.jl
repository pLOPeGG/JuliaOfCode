data = readlines()

function is_nice(s)
    count(∈("aeiou"), s) ≥ 3 && any(c == cc for (c, cc) in zip(s[1:end-1], s[2:end])) && !any(occursin.(split("ab cd pq xy"), Ref(s)))
end

function is_nice_2(s)
    !(isnothing(match(r"(..).*\1", s)) || isnothing(match(r"(.).\1", s)))
end

function solve_1()
    is_nice.(data) |> count
end


function solve_2()
    is_nice_2.(data) |> count
end


solve_1() |> println
solve_2() |> println