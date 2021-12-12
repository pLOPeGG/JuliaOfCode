using Pipe

const data = parse.(Int, reduce(hcat, collect.(readlines())))

neighbours(pos) = @pipe [
    CartesianIndex(Tuple(pos) .- (i, j)) 
    for i in (-1, 0, 1)
    for j in (-1, 0, 1)
    if (i, j) != (0, 0)
] |> filter(_) do I
    x, y = Tuple(I)
    x > 0 && y > 0 && x ≤ 10 && y ≤ 10
end

function step(grid)
    grid = copy(grid)
    grid .+= 1
    while any(grid .> 9)
        pos = argmax(grid)
        grid[pos] = typemin(Int64)

        nei = neighbours(pos)
        grid[nei] .+= 1
    end
    c = count(<(0), grid)
    grid[grid .< 0] .= 0
    
    grid, c
end

function step(grid, n)
    s = 0
    for i in 1:n
        grid, c = step(grid)
        s += c
    end
    grid, s
end

# Part One
step(data, 100)[2] |> println

# Part Two
let grid = data
    for i in 1:typemax(Int64)
        grid, c = step(grid)
        if c == 100
            println(i)
            break
        end
    end
end