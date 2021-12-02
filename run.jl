using ArgParse
using HTTP


function parse_arguments()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--year", "-y"
        help = "Year of AoC contest"
        arg_type = Int
        "--day", "-d"
        help = "Day of AoC problem"
        arg_type = Int
    end
    parse_args(s)
end

function load_aoc_file(year, day)
    filename = "$(year)/$(day).in"
    if !isfile(filename)
        cookie = Dict("session" => read("cookie", String))
        content = HTTP.request(:GET, "https://adventofcode.com/$(year)/day/$(day)/input", cookies = cookie).body |> String
        open(filename, "w") do io
            print(io, content)
        end
    end
end


function main()
    args = parse_arguments()

    load_aoc_file(args["year"], args["day"])

    prgrm_file = """$(args["year"])/$(args["day"]).jl"""
    input_file = """$(args["year"])/$(args["day"]).in"""

    cmd = `julia -t 6 $prgrm_file`
    run(pipeline(cmd, stdin = input_file))
end

main()