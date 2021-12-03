using Combinatorics

const data = parse.(Int, readlines())

function solve_1()
    n = 150
    dp = fill(0, (n + 1,))
    dp[1] = 1

    for d in data
        for i in n+1:-1:1
            if i+d <= n+1
                dp[i+d] += dp[i]
            end
        end
    end
    dp[end]
end

function solve_2()
    n = 150
    m = length(data)
    dp = zeros(Int, n+1, m+1)

    dp[1, 1] = 1

    for d in data
        for i in n+1:-1:1
            for j in 1:m
                if i+d <= n+1
                    dp[i+d, j+1] += dp[i, j]
                end
            end
        end
    end
    filter(>(0), dp[end, :])[1]
end

solve_1() |> println

solve_2() |> println