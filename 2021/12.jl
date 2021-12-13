using DataStructures

const data = split.(readlines(), Ref("-"))
const graph = begin
    g = DefaultDict{String, Vector{String}}([])
    for (u, v) in data
        push!(g[u], v)
        push!(g[v], u)
    end
    g
end

issmall(node) = all(islowercase.(collect(node)))

function dfs(node, small_seen; double_visit=nothing)
    node == "end" && return 1
    s = 0
    for nei in graph[node]
        if !issmall(nei) || nei ∉ small_seen
            small_seen_cp = copy(small_seen)
            issmall(nei) && push!(small_seen_cp, nei)
            s += dfs(nei, small_seen_cp; double_visit)
        elseif isnothing(double_visit) && nei != "start"
            small_seen_cp = copy(small_seen)
            s += dfs(nei, small_seen_cp; double_visit=nei)
        end
    end
    s
end

# Part One
dfs("start", Set(["start"]); double_visit="start") |> println

# Part Two
dfs("start", Set(["start"])) |> println
