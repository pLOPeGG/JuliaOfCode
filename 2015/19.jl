using Random

function parse_replace(l)
    u, _, v = split(l)
    u => v
end

lines = readlines()
const replacement = parse_replace.(lines[begin:end-2])
const mol = lines[end]

function step_mol(pattern; ker=mol)
    u, v = pattern
    s = Set()
    toks = split(ker, u)
    for i in 1:length(toks)-1
        new_mol = *(join(toks[begin:begin-1+i], u), v, join(toks[begin+i:end], u))
        push!(s, new_mol)
    end
    s
end

function step_parse(pattern; ker=mol)
    u, v = pattern
    s = Set()
    toks = split(ker, v)
    for i in 1:length(toks)-1
        new_mol = *(join(toks[begin:begin-1+i], v), u, join(toks[begin+i:end], v))
        push!(s, new_mol)
    end
    s
end

function gen_mol(ker, limit=10000)
    i = 0
    while true
        i += 1
        next_ker = rand(union(step_parse.(replacement; ker)...))
        if "e" == next_ker
            return i
        end
        if i > limit
            break
        end
        ker = next_ker
    end
    i
end

@show union(step_mol.(replacement)...) |> length

# Not always works
@show gen_mol(mol)
