using MLStyle
using Pipe
using Statistics

const data = readlines()

const char_pair = Dict([
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>',
])

const char_score = Dict([
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4,
])

function first_err_char(l)
    stack = []
    for c in l
        @match c begin
            cc && if cc ∈ keys(char_pair) end => push!(stack, cc)
            cc && if char_pair[stack[end]] == cc end => pop!(stack)
            cc => return cc, nothing
        end
    end
    return nothing, reverse(stack)
end

# Part One
@pipe data .|> first_err_char .|> get(char_score, _[1], 0) |> sum |> println

compute_score_completion(::Nothing) = 0
compute_score_completion(chars) = mapreduce((acc, x) -> 5acc + x, 
                                            chars; 
                                            init=0) do c
    get(char_score, c, nothing)
end


# Part Two
@pipe data .|> 
      first_err_char .|> 
      compute_score_completion(_[2]) |> 
      filter(>(0), _) |> 
      median |> 
      convert(Int, _) |> 
      println
