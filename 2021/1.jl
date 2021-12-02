using Pipe

const data = parse.(Int, readlines())

# Part One
@pipe data |> diff |> count(>(0), _) |> println

# Part Two
@pipe data[begin+3:end] - data[begin:end-3] |> count(>(0), _) |> println