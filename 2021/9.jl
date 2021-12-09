function parse_line(l)
    parse.(Int, collect(l))
end

const data = reduce(hcat, parse_line.(readlines()))

neighbours(pos) = [
    CartesianIndex(Tuple(pos) .- n) 
    for n ∈ ((-1, 0), (1, 0), (0, -1), (0, 1))
]

# Part One
sum(CartesianIndices(data)) do i
    neib = [get(data, neib, Inf) for neib ∈ neighbours(i)]
    all(
        data[i] < n for n in neib
    ) ? data[i] + 1 : 0
end |> println

function dfs(pos, seen::Set)
    curr_n = 1
    push!(seen, pos)
    for neib in neighbours(pos)
        neib ∉ CartesianIndices(data) && continue
        if neib ∉ seen
            curr_n += dfs(neib, seen)
        end
    end
    curr_n
end

function solve_2()
    seen_pos = Set(findall(==(9), data))
    remain_pos = setdiff(CartesianIndices(data), seen_pos)
    basins = []
    while !isempty(remain_pos)
        next_pos = pop!(remain_pos)
        push!(basins, dfs(next_pos, seen_pos))
        setdiff!(remain_pos, seen_pos)
    end
    partialsort!(basins, 3; rev=true)
    prod(basins[1:3])
end


# Part Two
solve_2() |> println
