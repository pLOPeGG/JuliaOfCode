const data = readlines()
m, n = length(data), length(data[1])

grid = [falses(m+2, 1);; reduce(hcat, [collect("."*d*".") .== '#' for d in data]);; falses(m+2, 1)] |> transpose

neighbours(g, i, j) = count(g[ii, jj] for ii in i-1:i+1 for jj in j-1:j+1) - g[i, j]

function step(g)
    gg = falses(size(g))
    for i in 2:m+1, j in 2:m+1
        if g[i, j]
            gg[i, j] = 2 <= neighbours(g, i, j) <= 3
        else
            gg[i, j] = neighbours(g, i, j) == 3
        end

        # Comment for part 1
        gg[[2, 2, m+1, m+1], [2, m+1, 2, m+1]] .= true
    end
    gg
end

function step(g, n) 
    for _ in 1:n 
        g = step(g)
    end
    g
end

step(grid,100) |> count |> println