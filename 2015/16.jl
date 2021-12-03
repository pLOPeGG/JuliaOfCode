const obj = Dict([
    "children"=> 3,
    "cats"=> 7,
    "samoyeds"=> 2,
    "pomeranians"=> 3,
    "akitas"=> 0,
    "vizslas"=> 0,
    "goldfish"=> 5,
    "trees"=> 3,
    "cars"=> 2,
    "perfumes"=> 1
])

function parse_line(l)
    n, o1, v1, o2, v2, o3, v3 = match(r"Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)", l).captures
    (parse(Int, n), Dict([
        o1=>parse(Int, v1),
        o2=>parse(Int, v2),
        o3=>parse(Int, v3),
    ]))
end

const data = parse_line.(readlines())

function correspond(d)
    i, infos = d
    all(v == obj[k] for (k, v) in infos)
end

function correspond2(d)
    i, infos = d
    b = true
    for (k, v) in infos
        if k in ("cats", "trees")
            b = b && v > obj[k]
        elseif k in ("pomeranians", "goldfish")
            b = b && v < obj[k]
        else
            b = b && v == obj[k]
        end
    end
    b
end

filter(correspond, data)[1] |> println
filter(correspond2, data)[1] |> println