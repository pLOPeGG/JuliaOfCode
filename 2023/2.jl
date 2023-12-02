bag = Dict(
    "red" => 12,
    "green" => 13,
    "blue" => 14)

function parseline(line)
    _, content = split(line, ": ")
    draws = split.(split(content, "; "), ", ")

    games = []
    for game in draws
        picked_colours = Dict{String,Int}()
        for hand in game
            n, colour = split(hand)
            nn = parse(Int, n)
            picked_colours[colour] = nn
        end
        push!(games, picked_colours)
    end
    games
end

data = readlines() .|> parseline

function solve1()
    sum(enumerate(data)) do (i, game)
        all(game) do hands
            all(hands) do (colour, n)
                bag[colour] >= n
            end

        end ? i : 0
    end
end

function solve2()
    sum(data) do game
        mini_bag = Dict(colour => 0 for colour in keys(bag))
        for hand in game
            for (c, n) in hand
                mini_bag[c] = max(n, mini_bag[c])
            end
        end
        prod(values(mini_bag))
    end

end

solve1() |> println
solve2() |> println