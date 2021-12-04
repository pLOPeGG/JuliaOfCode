input = readlines()

numbers = parse.(Int, split(input[1], ","))

function check_victory(m, drawn)
    if maximum(sum(drawn; dims=1)) == 5 || maximum(sum(drawn; dims=2)) == 5
        (@. m * !drawn) |> sum
    else
        0
    end
end

function solve()
    best = []
    for i in 1:100
        m = [
            parse.(Int, split(input[3 + (i-1)*6]));;
            parse.(Int, split(input[4 + (i-1)*6]));;
            parse.(Int, split(input[5 + (i-1)*6]));;
            parse.(Int, split(input[6 + (i-1)*6]));;
            parse.(Int, split(input[7 + (i-1)*6]))
        ]

        drawn = falses(size(m))

        for (j, n) in enumerate(numbers)
            pos = findnext(==(n), m, CartesianIndex(1, 1))
            if !isnothing(pos)
                drawn[pos] = true
            end
            score = check_victory(m, drawn)
            if score > 0
                score *= n
                push!(best, (j, score))
                break
            end
        end
    end
    sort!(best)
    best[begin], best[end]
end

# Part 1 and 2
solve() .|> println