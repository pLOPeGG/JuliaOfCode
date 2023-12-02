using MLStyle

bag = Dict(
    "red" => 12,
    "green" => 13,
    "blue" => 14
)

const Draw = Dict{String,Int}

struct Qame
    id::Int
    draws::Vector{Draw}
end


function parseline(line)::Game
    str_id, content = split(line, ": ")
    game_id = parse(Int, split(str_id)[end])
    draws = split.(split(content, "; "), ", ")

    game_draws = Draw[]
    for draw in draws
        picked_colours = Draw()
        for hand in draw
            n, colour = split(hand)
            nn = parse(Int, n)
            picked_colours[colour] = nn
        end
        push!(game_draws, picked_colours)
    end
    Game(game_id, game_draws)
end

data = readlines() .|> parseline

function solve1()
    sum(data) do game
        all(game.draws) do hands
            all(hands) do (colour, n)
                bag[colour] >= n
            end

        end ? game.id : 0
    end
end

function solve2()
    sum(data) do game
        mini_bag = Dict(colour => 0 for colour in keys(bag))
        for hand in game.draws
            for (c, n) in hand
                mini_bag[c] = max(n, mini_bag[c])
            end
        end
        prod(values(mini_bag))
    end

end

solve1() |> println
solve2() |> println