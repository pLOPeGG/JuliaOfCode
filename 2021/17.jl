CI = CartesianIndex

function parse_data(l)
    m = match(r".*x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)", l)
    x1, x2, y1, y2 = parse.(Int, m.captures)
    CI(x1, y1), CI(x2, y2)
end

const p1, p2 = parse_data(readline())

function step(pos, vel)
    pos = pos .+ vel
    vel = (sign(vel[1]) * (abs(vel[1]) - 1) , vel[2]-1)
    pos, vel
end

function step_until(vel, limit=500)
    pos = (0, 0)
    for i in 1:limit
        pos, vel = step(pos, vel)
        is_inside(pos) && return 1
        if pos[2] < p1.I[2] || pos[1] > p2.I[1] 
            break
        end
    end
    0
end

is_inside(pos) = CI(pos...) ∈ p1:p2

# Part One
let n = abs(p1.I[2])-1
    n*(n+1)÷2
end |> println

# Part Two
sum(step_until((velx, vely)) for velx in 1:300, vely in -200:300) |> println
