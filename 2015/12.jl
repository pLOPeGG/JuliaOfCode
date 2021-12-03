using JSON

const data = JSON.parse(readline())

# Remove ternary for part 1
sum_JSON(d::Dict) = "red" ∉ values(d) ? sum(sum_JSON.(values(d))) : 0

sum_JSON(a::Vector) = sum(sum_JSON.(a))

sum_JSON(n::Number) = n

sum_JSON(s::String) = 0

sum_JSON(data) |> println