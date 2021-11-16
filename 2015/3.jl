data = readline()

function move(mov)
    if mov == '^'
        [-1, 0]
    elseif mov == '>'
        [0, 1]
    elseif mov == 'v'
        [1, 0]
    else
        [0, -1]
    end
end


function solve_from(data)
    curr_position = [0, 0]
    positions = Set()
    push!(positions, curr_position)
    for mov in data
        curr_position += move(mov)
        push!(positions, curr_position)
    end
    positions
end

function solve_1()
    solve_from(data) |> length
end

function solve_2()
    union(solve_from(data[1:2:end]), solve_from(data[2:2:end])) |> length
end

solve_1() |> println
solve_2() |> println