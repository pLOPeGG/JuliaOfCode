using Base
using Chain

struct RangeIntersectError end

struct SeedRange
    beg::Int
    span::Int
end

SeedRange(a) = SeedRange(a[1], a[2])

struct Range
    dest::Int
    source::Int
    span::Int
end

function Base.in(item::Int, r::Range)
    item in r.source:r.source+r.span-1
end

function Base.in(item::SeedRange, r::Range)
    r.source <= item.beg < r.source + r.span || r.source <= item.beg + item.span - 1 < r.source + r.span || item.beg <= r.source < item.beg + item.span
end

struct Map
    ranges::Vector{Range}
end

function (r::Range)(item::Int)
    item + (r.dest - r.source)
end

function (r::Range)(item::SeedRange)
    res = SeedRange[]

    !(item in r) && throw(RangeIntersectError())

    before, after = nothing, nothing

    # Before
    if item.beg < r.source
        before = SeedRange(item.beg, r.source - item.beg)
    end

    # Mid
    intersection = SeedRange(
        max(item.beg, r.source) + (r.dest - r.source),
        min(item.beg + item.span, r.source + r.span) - max(item.beg, r.source)
    )

    # After
    if r.source + r.span < item.beg + item.span
        after = SeedRange(r.source + r.span, (item.beg + item.span) - (r.source + r.span))
    end

    before, intersection, after
end

function (m::Map)(item::Int)
    for r in m.ranges
        if item in r
            return r(item)
        end
    end
    item
end

function (m::Map)(item::SeedRange)
    res = SeedRange[]
    for r in m.ranges
        !(item in r) && continue

        before, inter, after = r(item)
        !isnothing(before) && push!(res, before)
        push!(res, inter)

        item = after
        isnothing(after) && break
    end
    !isnothing(item) && push!(res, item)
    res
end

function (m::Map)(item::Vector{SeedRange})
    res = SeedRange[]
    for seed in item
        append!(res, m(seed))
    end
    res
end

struct Converter
    from::String
    to::String
    map::Map
end

struct ConverterCollection
    converters::Dict{String,Converter}
end

function parseblock(block::AbstractString)::Converter
    block = split(block, "\n")
    from, to = @chain block[1] begin
        split
        _[1]
        split(_, "-")
        (_[1], _[3])
    end
    ranges = Range[]
    for line in block[2:end]
        dest, source, span = parse.(Int, split(line))
        push!(ranges, Range(dest, source, span))
    end
    sort!(ranges, by=r -> r.source)
    m = Map(ranges)
    Converter(from, to, m)
end

seeds, _, data... = readlines()
seeds = parse.(Int, split(seeds)[2:end])
data = @chain data begin
    join(_, "\n")
    split(_, "\n\n")
    parseblock.(_)
end

collection = ConverterCollection(Dict(
    c.from => c
    for c in data
))


function solve1(seeds::Vector{Int}, collection::ConverterCollection)
    pos = "seed"
    while haskey(collection.converters, pos)
        converter = collection.converters[pos]
        pos = converter.to
        seeds = converter.map.(seeds)
    end
    minimum(seeds)
end

function solve2(seeds::Vector{Int}, collection::ConverterCollection)
    pos = "seed"
    seeds = reshape(seeds, 2, :)
    seeds = SeedRange.(eachcol(seeds))

    while haskey(collection.converters, pos)
        converter = collection.converters[pos]
        pos = converter.to
        seeds = converter.map(seeds)
    end

    minimum(s.beg for s in seeds)
end

solve1(seeds, collection) |> println
solve2(seeds, collection) |> println