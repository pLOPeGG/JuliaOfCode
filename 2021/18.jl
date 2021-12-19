mutable struct Snailfish
    left::Union{Int, Snailfish}
    right::Union{Int, Snailfish}
    direction::Union{Nothing, Symbol}
    parent::Union{Nothing, Snailfish}

    function Snailfish(v::Vector; direction=nothing)
        s = new(
            typeof(v[1]) === Int ? v[1] : Snailfish(v[1]; direction=:left),
            typeof(v[2]) === Int ? v[2] : Snailfish(v[2]; direction=:right),
            direction,
            nothing
        )
        (typeof(s.left) === Snailfish) && (s.left.parent = s)
        (typeof(s.right) === Snailfish) && (s.right.parent = s)
        s
    end

    Snailfish(left, right, direction, parent) = new(left, right, direction, parent)
end

function Base.:+(s1::Snailfish, s2::Snailfish)
    s = Snailfish(deepcopy(s1), deepcopy(s2), nothing, nothing)
    s.left.parent = s
    s.left.direction = :left

    s.right.parent = s
    s.right.direction = :right

    reduce!(s)
    s
end

function reduce!(s::Snailfish)
    change = true
    while change
        change = explode!(s) || split!(s)
    end
    s
end

explode!(::Int; direction, depth) = false

function explode!(s::Snailfish; direction=nothing, depth=0)
    if depth < 4
        return explode!(s.left; direction=:left, depth=depth+1) || explode!(s.right; direction=:right, depth=depth+1)
    else
        bump_neighbour(s, :left, s.left)
        bump_neighbour(s, :right, s.right)
        
        setproperty!(s.parent, direction, 0)
        return true
    end
end

function bump_neighbour(s::Snailfish, direction, value)
    opposite_dir = direction == :left ? :right : :left
    if s.direction == direction
        while s.direction == direction
            s = s.parent
        end
    end
    if s.direction !== nothing
        s = s.parent
        if typeof(getproperty(s, direction)) === Snailfish
            s = getproperty(s, direction)
            
            while typeof(getproperty(s, opposite_dir)) === Snailfish
                s = getproperty(s, opposite_dir)
            end
            setproperty!(s, opposite_dir, getproperty(s, opposite_dir) + value)
        else
            setproperty!(s, direction, getproperty(s, direction) + value)
        end
    end
end

function split!(s::Snailfish)
    for dir in (:left, :right)
        if typeof(getproperty(s, dir)) === Snailfish
            split!(getproperty(s, dir)) && return true
        elseif getproperty(s, dir) > 9
            setproperty!(s, dir, Snailfish(
                getproperty(s, dir) ÷ 2,
                getproperty(s, dir) - (getproperty(s, dir) ÷ 2),
                dir,
                s
            ))
            return true
        end
    end
    false
end

magnitude(v::Int) = v
magnitude(s::Snailfish) = 3 * magnitude(s.left) + 2 * magnitude(s.right)

function parse_line(l)
    v = eval(Meta.parse(l))
    Snailfish(v)
end

const data = parse_line.(readlines())

# Part One
reduce(+, data) |> magnitude |> println

# Part Two
[
    data[i] + data[j]
    for i in eachindex(data), j in eachindex(data)
    if i != j
] .|> magnitude |> maximum |> println
