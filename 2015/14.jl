function parse_line(l)
    name, spd, dur, rst = match(r"(\w+)[ \D]+(\d+)[ \D]+(\d+)[ \D]+(\d+).*", l).captures
    (name, parse(Int, spd), parse(Int, dur), parse(Int, rst))
end

const data = parse_line.(readlines())
const time = 2503

function distance(spd, dur, rst, time)
    dst = zeros(Int, time+1)
    run = dur
    slp = 0
    for i in 2:time+1
        if run > 0
            dst[i] = dst[i-1] + spd
            run -= 1
            run == 0 && (slp = rst)
        else
            dst[i] = dst[i-1]
            slp -= 1
            slp == 0 && (run = dur)
        end
    end
    # @show dst
    dst
end

# Part 1
maximum(data) do (_, spd, dur, rst)
    distance(spd, dur, rst, time)[end]
end |> println


all_scores = reduce(hcat, [distance(spd, dur, rst, time) for (_, spd, dur, rst) in data])
best_score = maximum(all_scores; dims=2)

# Part 2
maximum(data) do (_, spd, dur, rst)
    (distance(spd, dur, rst, time) .== best_score) |> sum
end - 1 |> println
