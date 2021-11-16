using Combinatorics

function parse_line(l)
    m = match(r"^(?<from>\w+) to (?<to>\w+) = (?<dist>\d+)$", l)
    (from=m[:from], to=m[:to], dist=parse(Int, m[:dist]))
end


data = readlines() .|> parse_line





function tsp(g, f)
    n = length(g)
    cities = keys(g) |> collect

    function cost(order)
        c = 0
        pos = order[1]
        for next_pos in order[2:end]
            c += g[cities[pos]][cities[next_pos]]
            pos = next_pos
        end
        c
    end

    f(cost.(permutations(1:n)))
end

function solve_1()
    g = Dict{String, Dict{String, Int}}()
    for d in data
        from, to, dist = d
        dift = get!(g, from, Dict())
        dift[to] = dist
        ditf = get!(g, to, Dict())
        ditf[from] = dist
    end

    tsp(g, minimum)
end


function solve_2()
    g = Dict{String, Dict{String, Int}}()
    for d in data
        from, to, dist = d
        dift = get!(g, from, Dict())
        dift[to] = dist
        ditf = get!(g, to, Dict())
        ditf[from] = dist
    end

    tsp(g, maximum)
end

solve_1() |> println
solve_2() |> println