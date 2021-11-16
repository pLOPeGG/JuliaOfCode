data = readline()

function group(xs)
    ys = []
    push!(ys, [xs[1]])
    prev_y = xs[1]
    for x in xs[2:end]
        if x == prev_y
            push!(ys[end], x)
        else
            push!(ys, [x])
            prev_y = x
        end
    end
    ys
end

function step_audioactive(s)
    groups = group(s)
    join(["$(length(g))$(g[1])" for g in groups], "")
end


function solve_1()
    s = data
    for i in 1:50
        s = step_audioactive(s)
    end
    s
end

solve_1() |> length |> println