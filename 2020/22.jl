using Pipe
using DataStructures: Deque

struct Player
    id::Int
    cards::Deque{Int}
end

isempty(p::Player) = length(p.cards) == 0

function parse_player(player_block)
    lines = split(player_block, "\n")
    id = parse(Int, (lines[1]|>split)[end][begin:end-1])

    cards = parse.(Int, lines[2:end])
    dq = Deque{Int}()
    for c in cards
        push!(dq, c)
    end
    Player(id, dq)
end

function parse_lines(lines)
    players_cards = split(lines, "\n\n")
    parse_player.(players_cards)
end

data = @pipe readlines() |> join(_, "\n") |> parse_lines

function play!!(p1::Player, p2::Player)
    c1, c2 = popfirst!(p1.cards), popfirst!(p2.cards)
    if c1 > c2
        push!(p1.cards, c1)
        push!(p1.cards, c2)
    elseif c2 > c1
        push!(p2.cards, c2)
        push!(p2.cards, c1)
    else
    end
end

winner(p1::Player, p2::Player) = isempty(p1) ? (2, p2) : (1, p1)

function solve1(data)
    p1, p2 = data

    while !isempty(p1) && !isempty(p2)
        play!!(p1, p2)
    end

    _, p = winner(p1, p2)

    n = length(p.cards)
    collect(p.cards)' * collect(n:-1:1)
end

function play_rec!!!(p1::Player, p2::Player, memory)
    h = hash(collect(p1.cards)) * hash(collect(p2.cards))
    c1, c2 = popfirst!(p1.cards), popfirst!(p2.cards)
    if h in memory
        push!(p1.cards, c1)
        push!(p1.cards, c2)
        return
    end
    push!(memory, h)


    if length(p1.cards) < c1 || length(p2.cards) < c2
        if c1 > c2
            push!(p1.cards, c1)
            push!(p1.cards, c2)
        elseif c2 > c1
            push!(p2.cards, c2)
            push!(p2.cards, c1)
        else
            @warn "Identical cards"
        end
    else
        p1_copy = deepcopy(p1)
        p2_copy = deepcopy(p2)

        while length(p1_copy.cards) != c1
            pop!(p1_copy.cards)
        end
        while length(p2_copy.cards) != c2
            pop!(p2_copy.cards)
        end

        id_win, _ = solve2([p1_copy, p2_copy])
        if id_win == 1
            push!(p1.cards, c1)
            push!(p1.cards, c2)
        else
            push!(p2.cards, c2)
            push!(p2.cards, c1)
        end
    end
end

function solve2(data)
    p1, p2 = data
    memory = Set()
    while !(isempty(p1) || isempty(p2))
        play_rec!!!(p1, p2, memory)
    end

    i, p = winner(p1, p2)

    n = length(p.cards)
    i, collect(p.cards)' * collect(n:-1:1)
end

data |> deepcopy |> solve1 |> println
data |> deepcopy |> solve2 |> last |> println