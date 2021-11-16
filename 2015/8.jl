data = readlines()

function inner_string_size(s)
    n = 0
    pass_next = 0
    for (c1, c2) in zip(s[2:end-1], s[3:end])
        if pass_next > 0
            pass_next -= 1
            continue
        end
        if c1 == '\\'
            if c2 == 'x'
                pass_next = 3
            else
                pass_next = 1
            end
        end
        n += 1
    end
    n
end

function solve_1()
    tot_len = data .|> length |> sum
    tot_inner = data .|> inner_string_size |> sum
    tot_len - tot_inner
end

function outer_string_size(s)
    count(occursin("\\\""), s) + 2
end

function solve_2()
    tot_out = data .|> outer_string_size |> sum
    tot_out
end

solve_1() |> println
solve_2() |> println