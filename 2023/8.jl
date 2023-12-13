using MLStyle

@data Move begin
    L
    R
end

function convert(::Type{Move}, c::Char)
    @match c begin
        'L' => L
        'R' => R
        _ => throw(ErrorException("Wrong move"))
    end
end

Node = String

struct Maze
    node_map::Dict{Node,Tuple{Node,Node}}
end

function move(m::Maze, pos::Node, instr::Move)
    @match instr begin
        L => m.node_map[pos][1]
        R => m.node_map[pos][2]
    end
end

pair_node_re = r"(?<node>\w+) = \((?<left>\w+), (?<right>\w+)\)"
function parse(::Type{Pair{Node,Tuple{Node,Node}}}, s::AbstractString)
    m = match(pair_node_re, s)
    m["node"] => (m["left"], m["right"])
end

function parselines(lines)
    moves = convert.(Move, collect(lines[1]))

    links = parse.(Pair{Node,Tuple{Node,Node}}, lines[3:end])

    moves, Maze(Dict(links...))
end

function solve1(data)
    moves, maze::Maze = data
    n = 1
    pos = "AAA"
    while pos != "ZZZ"
        instr = moves[mod1(n, length(moves))]

        new_pos = move(maze, pos, instr)
        pos = new_pos

        n += 1
    end
    n - 1
end

function solve2(data)
    moves, maze::Maze = data
    starts = filter(s -> s[end] == 'A', keys(maze.node_map))

    durations = map(collect(starts)) do s
        n = 1
        pos = s
        while pos[end] != 'Z'
            instr = moves[mod1(n, length(moves))]

            new_pos = move(maze, pos, instr)
            pos = new_pos

            n += 1
        end
        n - 1
    end

    lcm(durations...)
end


data = readlines() |> parselines

data |> solve1 |> println
data |> solve2 |> println

