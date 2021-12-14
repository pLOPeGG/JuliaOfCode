const lines = readlines()

parse_dot(l) = CartesianIndex((1 .+ parse.(Int, split(l, ",")))...)
function parse_fold(l)
    axis, v = split(l, "=")
    axis = Symbol(axis[end])
    v = parse(Int, v) + 1
    axis, v
end

const dots = parse_dot.(lines[begin:793])
const folds = parse_fold.(lines[795:end])

const paper = begin
    p = falses(maximum(dots).I)
    p[dots] .= true
    p
end

function fold(m, ::Val{:x}, pos)
    xsize = size(m, 1)
    n = copy(m[begin:pos-1, :])
    for I in CartesianIndices(n)
        xx, yy = I.I
        if (2pos - xx) ≤ xsize
            n[I] |= m[2pos-xx, yy]
        end
    end
    n
end

function fold(m, ::Val{:y}, pos)
    ysize = size(m, 2)
    n = copy(m[:, begin:pos-1])
    for I in CartesianIndices(n)
        xx, yy = I.I
        if (2pos - yy) ≤ ysize
            n[I] |= m[xx, 2pos-yy]
        end
    end
    n
end

fold(m, s::Symbol, pos) = fold(m, Val{s}(), pos)

# Part One
fold(paper, folds[1]...) |> count |> println

# Part Two
let pp = paper
    for f in folds
        pp = fold(pp, f...)
    end
    for r in eachcol(pp)
        println(join([rr ? "#" : " " for rr in r]))
    end
end