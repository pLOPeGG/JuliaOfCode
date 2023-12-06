using Chain


struct Race
    time::Int
    dist::Int
end

function parseinput(lines)
    t = @chain lines[1] begin
        split
        _[2:end]
        parse.(Int, _)
    end
    d = @chain lines[2] begin
        split
        _[2:end]
        parse.(Int, _)
    end
    res = Race[]
    for (tt, dd) in zip(t, d)
        push!(res, Race(tt, dd))
    end
    res
end

data = readlines() |> parseinput

function simulate(t_wait::Int, t_max::Int)
    (t_max - t_wait) * t_wait
end

function simulate_all(t_max)
    simulate.(0:t_max, Ref(t_max))
end


function solve1(data::Vector{Race})
    res = Int[]
    for race in data
        scores = simulate_all(race.time)
        push!(res, count(>(race.dist), scores))
    end
    prod(res)
end

function solve2(data::Vector{Race})
    race = Race(
        parse(Int, join([r.time for r in data])),
        parse(Int, join([r.dist for r in data])),
    )

    scores = simulate_all(race.time)
    count(>(race.dist), scores)
end

data |> solve1 |> println
data |> solve2 |> println