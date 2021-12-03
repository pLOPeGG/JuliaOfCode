const data = readlines()
const m = length(data[1])

most_common(j; d=data) = sum(1:length(d)) do i 
                             d[i][j] == '1'
                         end >= length(d) / 2 ? '1' : '0'

least_common(j; d=data) = most_common(j; d) == '1' ? '0' : '1'

Base.parse(cs::Vector{Char}) = parse(Int, join(cs); base=2)

# Part 1
(most_common.(1:m), least_common.(1:m)) .|> parse |> prod |> println

function rating(f; d=data)
    values = copy(d)
    for j in 1:m
        b = f(j; d=values)
        filter!(values) do num
            num[j] == b
        end
        length(values) == 1 && break
    end
    collect(values[1])
end

# Part 2
(most_common, least_common) .|> rating .|> parse |> prod |> println
