using Combinatorics
using MLStyle

function parse_line(l)
    @match match(r"(\w+) would (lose|gain) (\d+) .* (\w+)\.", l).captures begin
        [u, "lose", n, v] => (u, v, -parse(Int, n))
        [u, "gain", n, v] => (u, v,  parse(Int, n))
        _ => nothing
    end
end

const data = parse_line.(readlines())
const g = begin 
    gg = Dict{String, Dict{String, Int}}()
    for (u, v, n) in data
        get!(gg, u, Dict())[v] = n
    end
    gg
end

function happiness(names)
    n = length(names)
    sum(1:n) do i
        get(get(g, names[i], Dict()), names[mod1(i+1, n)], 0) + get(get(g, names[i], Dict()), names[mod1(i-1, n)], 0)
    end
end

# Part 1
g |> keys |> collect |> permutations .|> happiness |> maximum |> println

# Part 2
[collect(keys(g)); "Me"] |> permutations .|> happiness |> maximum |> println