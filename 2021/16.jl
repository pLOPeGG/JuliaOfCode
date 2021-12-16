using MLStyle

const data = join(bitstring.(hex2bytes(readline())))
const HEADER_SIZE = 6
const N_PACKETS_MANTISSA_SIZE = 11
const N_BITS_MANTISSA_SIZE = 15

bits2int(bs) = parse(Int, bs; base = 2)

@data Packet begin
    Literal(version::Int, value::Int)
    Operation(version::Int, op,  operands::Vector{Packet})
end

function parse_packet(bits)
    v = bits2int(bits[begin:3])
    t = bits2int(bits[4:6])
    packet, incr = @match t begin
        4 => parse_literal(v, bits[HEADER_SIZE + 1:end])
        _ => parse_operation(v, t, bits[HEADER_SIZE + 1:end])
    end
    packet, incr
end

function parse_literal(version, bits)
    i, guard, s = 1, '1', []

    while guard == '1'
        quintet = bits[i:i+4]
        push!(s, quintet[2:end])

        guard = quintet[1]
        i += 5
    end
    Literal(version, bits2int(join(s))), (i + HEADER_SIZE - 1)
end

function parse_operation(version, op, bits)
    val, incr = @match bits[1] begin
        '0' => begin
            l = bits2int(bits[2:2+N_BITS_MANTISSA_SIZE-1])
            parse_all_packets(bits[2+N_BITS_MANTISSA_SIZE:2+N_BITS_MANTISSA_SIZE+l-1])
        end
        '1' => begin
            l = bits2int(bits[2:2+N_PACKETS_MANTISSA_SIZE-1])
            parse_n_packets(bits[2+N_PACKETS_MANTISSA_SIZE:end], l)
        end
    end
    Operation(version, op, val), incr
end

function parse_all_packets(bits)
    l = []
    offset = 1
    while offset <= length(bits)
        packet, incr = parse_packet(bits[offset:end])
        offset += incr
        push!(l, packet)
    end
    l, offset + HEADER_SIZE + N_BITS_MANTISSA_SIZE
end

function parse_n_packets(bits, n)
    l = []
    offset = 1
    for _ in 1:n
        packet, incr = parse_packet(bits[offset:end])
        offset += incr
        push!(l, packet)
    end
    l, offset + HEADER_SIZE + N_PACKETS_MANTISSA_SIZE
end

parse_bits(bits) = parse_packet(bits) |> first

sum_versions(packet) = @match packet begin
    Literal(;version) => version
    Operation(;version, operands) => sum(sum_versions.(operands)) + version
end

eval(packet::Packet) = @match packet begin
    Literal(_, value) => value
    Operation(_, 0, operands) =>  sum(eval.(operands))
    Operation(_, 1, operands) => prod(eval.(operands))
    Operation(_, 2, operands) => minimum(eval.(operands))
    Operation(_, 3, operands) => maximum(eval.(operands))
    Operation(_, 5, operands) =>  >(eval.(operands)[1:2]...) ? 1 : 0
    Operation(_, 6, operands) =>  <(eval.(operands)[1:2]...) ? 1 : 0
    Operation(_, 7, operands) => ==(eval.(operands)[1:2]...) ? 1 : 0
end

# Part One
data |> parse_bits |> sum_versions |> println

# Part Two
data |> parse_bits |> eval |> println
