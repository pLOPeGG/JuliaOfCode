struct Card
    id::Int
    winning::Vector{Int}
    hand::Vector{Int}
end

function parseline(line)
    beg, cards = split(line, ": ")
    id = parse(Int, split(beg)[end])
    p_win, p_hand = split(cards, " | ")
    winning = parse.(Int, filter(!isempty, split(p_win, " ")))
    hand = parse.(Int, filter(!isempty, split(p_hand, " ")))
    Card(id, winning, hand)
end

data = readlines() .|> parseline

function winning_number(c::Card)
    length(intersect(c.winning, c.hand))
end

function solve1()
    sum(data) do card
        n = winning_number(card)
        n == 0 && return 0
        2^(n - 1)
    end
end

function solve2()
    copies = ones(Int, length(data))
    win_numbers = winning_number.(data)

    for (i, wn) in enumerate(win_numbers)
        wn == 0 && continue
        new_cards = ones(Int, wn) .* copies[i]
        copies[i+1:i+wn] .+= new_cards
    end
    sum(copies)
end

solve1() |> println
solve2() |> println