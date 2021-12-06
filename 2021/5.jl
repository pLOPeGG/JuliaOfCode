using Pipe

function parse_line(l)
    lhs, rhs = split(l, " -> ")
    x₁, y₁ = 1 .+ parse.(Int, split(lhs, ","))
    x₂, y₂ = 1 .+ parse.(Int, split(rhs, ","))
    @pipe ((x₁,x₂), (y₁,y₂)) .|> make_range(_...)
end

make_range(u, v) = u ≤ v ? (u:v) : (u:-1:v) 

const data = parse_line.(readlines())

grid = zeros(Int, (1000, 1000))
for (r_x, r_y) in data
    (length(r_x) > 1) ⊻ (length(r_y) > 1) && (grid[r_x, r_y] .+= 1)
    
    # Comment for Part 1
    length(r_y) == length(r_x) && for (xx, yy) in zip(r_x, r_y)
        grid[xx, yy] += 1
    end
end

@pipe grid |> count(≥(2), _) |> println