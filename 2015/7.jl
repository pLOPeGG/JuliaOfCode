function try_parse(s)
    if all(isnumeric, s)
        parse(Int, s)
    else
        s
    end
end

struct BinaryOp
    op
    in_1
    in_2
    out

    BinaryOp(op, in_1::AbstractString, in_2::AbstractString, out) = new(op, try_parse(in_1), try_parse(in_2), out)
end

struct UnaryOp
    op
    in_
    out

    UnaryOp(op, in_::AbstractString, out) = new(op, try_parse(in_), out)
end

function parse_line(l)
    m_simple = match(r"^(?<op>NOT)? ?(?<in_>\S+) -> (?<out>\w+)$", l)
    m_double = match(r"^(?<in_1>\S+) (?<op>AND|OR|RSHIFT|LSHIFT) (?<in_2>\S+) -> (?<out>\w+)$", l)
    
    if !isnothing(m_simple)
        UnaryOp(m_simple[:op], m_simple[:in_], m_simple[:out])
    elseif !isnothing(m_double)
        BinaryOp(m_double[:op],m_double[:in_1], m_double[:in_2], m_double[:out])
    else
        @error "Did not parse $l"
    end
end

data = readlines() .|> parse_line

function apply(assgn::UnaryOp, mem)
    in_ = assgn.in_
    if in_ isa AbstractString
        in_ = mem[in_]
    end
    if !isnothing(assgn.op)
        ~in_
    else
        in_
    end
end

function apply(assgn::BinaryOp, mem)
    in_1 = assgn.in_1
    if in_1 isa AbstractString
        in_1 = mem[in_1]
    end
    in_2 = assgn.in_2
    if in_2 isa AbstractString
        in_2 = mem[in_2]
    end

    if assgn.op == "AND"
        in_1 & in_2
    elseif assgn.op == "OR"
        in_1 | in_2
    elseif assgn.op == "RSHIFT"
        in_1 >> in_2
    elseif assgn.op == "LSHIFT"
        in_1 << in_2
    else
        @error "No operation in $assgn"
    end
end

function compute(assgn::UnaryOp, circuit, mem)
    out_key = assgn.out
    if haskey(mem, out_key)
        return mem[out_key]
    end
    
    in_ = assgn.in_
    if in_ isa AbstractString && !haskey(mem, in_)
        compute(circuit[in_], circuit, mem)
    end
    out = apply(assgn, mem)
    mem[out_key] = out
    return out
end

function compute(assgn::BinaryOp, circuit, mem)
    out_key = assgn.out
    if haskey(mem, out_key)
        return mem[out_key]
    end

    in_1 = assgn.in_1
    if in_1 isa AbstractString && !haskey(mem, in_1)
        compute(circuit[in_1], circuit, mem)
    end

    in_2 = assgn.in_2
    if in_2 isa AbstractString && !haskey(mem, in_2)
        compute(circuit[in_2], circuit, mem)
    end

    out = apply(assgn, mem)
    mem[out_key] = out
    return out
end

function solve_1()
    g_struct = Dict{String, Union{UnaryOp, BinaryOp}}()
    g_val = Dict{String, Int}()
    for line in data
        g_struct[line.out] = line
    end

    compute(g_struct["a"], g_struct, g_val)

end

solve_1() |> println