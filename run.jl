using ArgParse


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
    return parse_args(s)
end


function main()
    args = parse_arguments()

    prgrm_file = """$(args["year"])/$(args["day"]).jl"""
    input_file = """$(args["year"])/$(args["day"]).in"""

    cmd = `julia -t 6 $prgrm_file`
    run(pipeline(cmd, stdin=input_file))
end

main()