using MLStyle

const data = join(bitstring.(hex2bytes(readline())))

function parse_value(bits)
    i = 1
    quintet = bits[i:i+4]
    s = []
    while quintet[1] == '1'
        push!(s, quintet[2:end])
        i += 5
        quintet = bits[i:i+4]
    end
    push!(s, quintet[2:end])

    parse(Int, join(s); base = 2)
end

function parse_packet(bits)
    v = parse(Int, bits[begin:3]; base = 2)
    t = parse(Int, bits[4:6]; base = 2)
    @show t
    @match t begin
        4 => parse_value(bits[7:end])

        _ => begin

        end
    end
end

# packet = parse_packet(data)

parse_packet("110100101111111000101000") |> println