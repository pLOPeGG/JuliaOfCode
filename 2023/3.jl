struct Position
    x::Int
    y::Int
end

function Base.:+(p::Position, o::Position)
    return Position(p.x + o.x, p.y + o.y)
end

function Base.:+(p::Position, o::Tuple{Int,Int})
    return Position(p.x + o[1], p.y + o[2])
end

function neighbour(p::Position)::Vector{Position}
    return [
        p + (i, j)
        for i in -1:1, j in -1:1
        if (i, j) != 0
    ]
end

struct Number
    value::Int
    pos::Vector{Position}
end

struct Symbol
    char::Char
    pos::Position
end

struct Map
    symbol_positions::Set{Position}
    numbers::Vector{Number}
    symbols::Vector{Symbol}
end


function parseline(line, line_id::Int)
    values = filter(split(line, !isdigit)) do s
        !isempty(s)
    end

    val_pos = Vector{Position}[]
    curr_value = 1
    curr_value_counter = 1
    curr_value_pos = Position[]

    symbol_positions = Position[]
    symbols = Symbol[]
    for (i, c) in enumerate(line)
        if isdigit(c)
            push!(curr_value_pos, Position(line_id, i))
            curr_value_counter += 1

            if curr_value_counter > length(values[curr_value])
                push!(val_pos, curr_value_pos)
                curr_value_pos = Position[]
                curr_value_counter = 1
                curr_value += 1
            end
        elseif c != '.'
            push!(symbol_positions, Position(line_id, i))
            push!(symbols, Symbol(c, Position(line_id, i)))
        end

    end

    return symbol_positions, [
        Number(parse(Int, v), v_pos)
        for (v, v_pos) in zip(values, val_pos)
    ], symbols
end


function parselines(data)
    all_symbol_pos = Set()
    all_values = Number[]
    all_symbols = Symbol[]
    for (i, line) in enumerate(data)
        symbol_pos, values, symbols = parseline(line, i)
        union!(all_symbol_pos, symbol_pos)
        append!(all_values, values)
        append!(all_symbols, symbols)

    end
    return Map(all_symbol_pos, all_values, all_symbols)
end


data = readlines() |> parselines

function solve1(map::Map)
    part_values = []
    for number in map.numbers
        if any(number.pos) do pos
            any(p in map.symbol_positions for p in neighbour(pos))
        end

            push!(part_values, number.value)
        end
    end
    sum(part_values)
end

function solve2(map::Map)
    gears = []
    for symbol in map.symbols
        symbol.char != '*' && continue
        symbol_neighbours = Set(neighbour(symbol.pos))
        symbol_number_neighbours = [
            n
            for n in map.numbers
            if any(p in symbol_neighbours for p in n.pos)
        ]

        if length(symbol_number_neighbours) == 2
            push!(gears, prod(n.value for n in symbol_number_neighbours))
        end
    end
    sum(gears)
end

data |> solve1 |> println
data |> solve2 |> println