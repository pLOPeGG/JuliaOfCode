using DataStructures
using Pipe

function parse_template(l)::Pair{Tuple{Char, Char}, Char}
    lhs, rhs = split(l, " -> ")
    Tuple(lhs) => rhs[1]
end

const word = readuntil(Base.stdin, "\n\n")
const templates = Dict(parse_template.(readlines()))

pairwise(xs) = zip(xs, last(Iterators.peel(xs)))

function step(polymer)
    new_polymer = []
    for (c1, c2) in pairwise(polymer)
        push!(new_polymer, c1)
        if haskey(templates, (c1, c2))
            push!(new_polymer, templates[(c1, c2)])
        end
    end
    push!(new_polymer, polymer[end])
    join(new_polymer)
end

function step(polymer, n::Int)
    for _ in 1:n
        polymer = step(polymer)
    end
    polymer
end

# Part One
@pipe step(word, 10) |>
      collect |>
      counter |>
      values |>
      maximum(_) - minimum(_) |>
      println

const all_chars = unique(values(templates))
const n_chars = length(all_chars)
const n_pairs = n_chars^2
const pairs = [(c1, c2) for c1 in all_chars for c2 in all_chars]

# Building a dp table n_pairs × n_pairs
# Each line provides what the current pair will produce after one step
# It is either itself (1 on the diagonal)
#       or 2 new pairs formed by inserting a char inbetween 
const dp_mem = begin
    dp = zeros(Int, n_pairs, n_pairs)
    for i in 1:n_pairs
        if haskey(templates, pairs[i])
            c_inter = templates[pairs[i]]
            for t in ((pairs[i][1], c_inter), (c_inter, pairs[i][2]))
                j = findfirst(==(t), pairs)
                dp[i, j] = 1
            end
        else
            dp[i, i] = 1
        end
    end
    dp
end

function count_occurences(polymer, n::Int)
    # Exponentiations on `dp_mem` computes what a given pair produces after `n` steps
    # Julia automatically uses fast exponentiations <3 so we could do the same computation
    # for very large numbers (using BigInt instead of Int64)
    occurence_table = dp_mem^n

    char_count = zeros(Int, n_chars)
    pair_count = zeros(Int, n_pairs)
    
    # Counting pairs first
    for p in pairwise(polymer)
        i = findfirst(==(p), pairs)
        pair_count .+= occurence_table[i, :]
    end
    # Now counting chars
    for (i, n_p) in enumerate(pair_count)
        for c in pairs[i]
            char_count[findfirst(==(c), all_chars)] += n_p
        end
    end
    # Chars are counted twice (they all belong to 2 pairs)
    # Except for first and last char of polymer sequence
    char_count[findfirst(==(polymer[1]), all_chars)] += 1
    char_count[findfirst(==(polymer[end]), all_chars)] += 1
    char_count .÷ 2
end

# Part Two
@pipe count_occurences(word, 40) |>
      maximum(_) - minimum(_) |>
      println