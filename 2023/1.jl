using Chain
using Pipe

numbers = [
    ("one", 1),
    ("two", 2),
    ("three", 3),
    ("four", 4),
    ("five", 5),
    ("six", 6),
    ("seven", 7),
    ("eight", 8),
    ("nine", 9)
]

function parseline1(line)
    @chain line begin
        collect(_)
        filter(isnumeric, _)
        parse.(Ref(Int), _)
        (_[begin], _[end])
    end
end

function parseline2(line)
    for (ns, nv) in numbers
        line = replace(line, ns => "$(ns)$(nv)$(ns)")
    end
    parseline1(line)
end

lines = readlines()
data1 = lines .|> parseline1
data2 = lines .|> parseline2

println(@pipe data1 .|> _[1] * 10 + _[2] |> sum)
println(@pipe data2 .|> _[1] * 10 + _[2] |> sum)