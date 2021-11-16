data = readline()


function increment(c::Char)
    if c == 'z'
        return 'a'
    end
    return c + 1
end

function increment(s::String)
    if s[end] == 'z'
        return increment(s[1:end-1]) * increment(s[end])
    end
    return s[1:end-1] * increment(s[end])
end

function check(s)
    rule_1 = false
    for i in 1:length(s)-2
        if s[i]+2 == s[i+1]+1 == s[i+2]
            rule_1 = true
        end
    end
    rule_2 = !occursin.("iol", Ref(s))
    rule_3 = length(eachmatch(r"(.)\1", s, overlap=false) |> collect) >= 2
    rule_1 && rule_2 && rule_3
end


function solve_1()
    s = data |> increment
    while !check(s)
        s = increment(s)
    end
    s
end

solve_1() |> println