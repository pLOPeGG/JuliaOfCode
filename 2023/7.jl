using MLStyle
using Base
using DataStructures

@enum Card begin
    J = -1
    Two = 0
    Three
    Four
    Five
    Six
    Seven
    Eight
    Nine
    T
    # J
    Q
    K
    A
end

function Base.convert(::Type{Card}, c::Char)
    @match c begin
        '2' => Two
        '3' => Three
        '4' => Four
        '5' => Five
        '6' => Six
        '7' => Seven
        '8' => Eight
        '9' => Nine
        'T' => T
        'J' => J
        'Q' => Q
        'K' => K
        'A' => A
        _ => throw(ErrorException("Unknown card"))
    end
end

@data HandCombination begin
    HighCard(val::Card)
    SinglePair(val::Card)
    DoublePair(val1::Card, val2::Card)
    Brelan(val::Card)
    FullHouse(val1::Card, val2::Card)
    Carre(val::Card)
    Penta(val::Card)
end

function Base.parse(::Type{Int}, hc::HandCombination)
    @match hc begin
        HandCombination::HighCard => 0
        HandCombination::SinglePair => 1
        HandCombination::DoublePair => 2
        HandCombination::Brelan => 3
        HandCombination::FullHouse => 4
        HandCombination::Carre => 5
        HandCombination::Penta => 6
    end
end

function Base.:<(hc1::HandCombination, hc2::HandCombination)
    @match (hc1, hc2) begin
        (HighCard(c1), HighCard(c2)) => c1 < c2
        (SinglePair(c1), SinglePair(c2)) => c1 < c2
        (DoublePair(c11, c12), DoublePair(c21, c22)) => (c11, c12) < (c21, c22)
        (Brelan(c1), Brelan(c2)) => c1 < c2
        (FullHouse(c11, c12), FullHouse(c21, c22)) => (c11, c12) < (c21, c22)
        (Carre(c1), Carre(c2)) => c1 < c2
        (Penta(c1), Penta(c2)) => c1 < c2
        _ => parse(Int, hc1) < parse(Int, hc2)
    end
end

Base.isless(hc1::HandCombination, hc2::HandCombination) = hc1 < hc2

struct Hand
    cards::Vector{HandCombination}
    str::String
end

@as_record Hand

function Base.:<(h1::Hand, h2::Hand)
    @match (h1, h2) begin
        (Hand(hc1, s1), Hand(hc2, s2)) && if typeof(hc1[1]) == typeof(hc2[1])
        end => convert.(Card, collect(s1)) < convert.(Card, collect(s2))
        (Hand(hc1, _), Hand(hc2, _)) => hc1 < hc2
        _ => throw(ErrorException("zfoin"))
    end
end

Base.isless(h1::Hand, h2::Hand) = h1 < h2


function Base.parse(::Type{Hand}, s::AbstractString)
    c = counter(collect(s))
    hand_v = HandCombination[]

    n_j = c['J']
    c['J'] = 0

    cc = collect(c)
    sort!(cc, by=x -> (x[2], convert(Card, x[1])), rev=true)

    for (card, card_count) in cc
        card_count == 0 && length(cc) > 1 && continue
        push!(hand_v, @match card_count + n_j begin
            1 => HighCard(card)
            2 => SinglePair(card)
            3 => Brelan(card)
            4 => Carre(card)
            5 => Penta(card)
            _ => throw(ErrorException("Too many cards"))
        end)
        n_j = 0
    end
    c_types = counter(collect(typeof.(hand_v)))
    if c_types[SinglePair] == 2
        pair_values = sort([sp.val for sp in hand_v if typeof(sp) == SinglePair])
        filter!(hc -> typeof(hc) != SinglePair, hand_v)
        push!(hand_v, DoublePair(pair_values[2], pair_values[1]))
    end
    if c_types[Brelan] == 1 && c_types[SinglePair] == 1
        brelan_value = [br.val for br in hand_v if typeof(br) == Brelan][1]
        pair_value = [sp.val for sp in hand_v if typeof(sp) == SinglePair][1]
        filter!(hc -> !(typeof(hc) in [SinglePair, Brelan]), hand_v)
        push!(hand_v, FullHouse(brelan_value, pair_value))
    end
    sort!(hand_v, rev=true)
    Hand(hand_v, s)
end

function parseline(line)
    cards, bid = split(line)
    parse(Hand, cards), parse(Int, bid)
end



function solve1(data)
    sorted_data = deepcopy(data)
    sort!(sorted_data)

    open("dump.txt", "w") do file
        for (hand, _) in sorted_data
            write(file, "$hand\n")
        end
    end

    for (i, (h1, _)) in enumerate(sorted_data)
        for (j, (h2, _)) in enumerate(sorted_data)
            @assert (i < j) == (h1 < h2) "$i $j $h1 $h2"
        end
    end
    sum(enumerate(sorted_data)) do (i, (_, bid))
        i * bid
    end
end

data = readlines() .|> parseline
data |> solve1 |> println