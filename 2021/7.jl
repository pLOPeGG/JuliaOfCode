const data = parse.(Int, split(readline(), ","))

# Part One

minimum(UnitRange(extrema(data)...)) do i 
    sum(abs.(data .- i))
end |> println

# Part Two

minimum(UnitRange(extrema(data)...)) do i
    sum(data) do d
        abs(d - i) * (abs(d - i) + 1) ÷ 2
    end
end |> println