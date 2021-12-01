using Pipe
using DSP

const data = parse.(Int, readlines())

# Part One
@pipe data |> diff |> count(>(0), _) |> println

# Part Two
@pipe conv(data, ones(3))[3:end-2] |> diff |> count(>(0), _) |> println