using Chain

groups = @chain readlines() begin
    join(_, "_")
    split(_, "__")
end
sum_groups = [parse.(Int, split(g, "_")) for g in groups] .|>
             sum |>
             sort

sum_groups[end] |> println
sum_groups[end-2:end] |> sum |> println


