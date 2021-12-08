using Combinatorics

function parse_line(l)
    lhs, rhs = split(l ," | ")
    digits = split(lhs)
    output = split(rhs)
    digits, output
end

const data = parse_line.(readlines())

# Part One

sum(data) do (_, out)
    count(∈((2, 3, 4, 7)), length.(out))
end |> println

# ------------------------------

# Mapping from segments on to corresponding digit
const segments2digit = Dict(
    [1, 2, 3, 5, 6, 7]    => 0,
    [3, 6]                => 1,
    [1, 3, 4, 5, 7]       => 2,
    [1, 3, 4, 6, 7]       => 3,
    [2, 3, 4, 6]          => 4,
    [1, 2, 4, 6, 7]       => 5,
    [1, 2, 4, 5, 6, 7]    => 6,
    [1, 3, 6]             => 7,
    [1, 2, 3, 4, 5, 6, 7] => 8,
    [1, 2, 3, 4, 6, 7]    => 9
)

is_decode_key(perm::Vector, digits) = all( 
            sort([findfirst(==(seg), perm) for seg in digit]) ∈ keys(segments2digit)
            for digit in digits 
        )

decode(digit, perm::Vector) = get(segments2digit, sort([findfirst(==(seg), perm) for seg in digit]), nothing)

function decode(digits::Vector)
    for perm in permutations("abcdefg")
        if is_decode_key(perm, digits)
            return perm
        end
    end
    nothing
end

# Part Two

sum(data) do (digits, output)
    perm_key = decode(digits)
    sum(decode(d, perm_key)*10^i for (i, d) in zip(3:-1:0, output))
end |> println