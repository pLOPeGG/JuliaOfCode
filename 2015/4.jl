using MD5

data = readline()

function solve_1()
    for i in 0:10^7
        md = bytes2hex(md5("$(data)$(i)"))
        if startswith(md, "0"^6)
            return i
        end
    end
end

solve_1() |> println