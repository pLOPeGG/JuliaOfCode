using JSON

const data = JSON.parse(readline())

# Remove ternary for part 1
JSON_value(d::Dict) = "red" ∉ values(d) ? sum(JSON_value.(values(d))) : 0

JSON_value(a::Vector) = sum(JSON_value.(a))

JSON_value(n::Number) = n

JSON_value(s::String) = 0

JSON_value(data) |> println