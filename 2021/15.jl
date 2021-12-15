using DataStructures

const data = parse.(Int, reduce(hcat, collect.(readlines())))

neighbours(pos) =
    filter([
        CartesianIndex(pos.I .- n)
        for n ∈ ((-1, 0), (1, 0), (0, -1), (0, 1))
    ]) do I
        1 <= I.I[1] <= size(data, 1) && 1 <= I.I[2] <= size(data, 2)
    end

function dijkstra(start, finish)
    q = PriorityQueue{CartesianIndex,Int}(Base.Order.Forward)
    seen = Set{CartesianIndex}()

    enqueue!(q, start => data[start])

    while !isempty(q)
        pos, d = dequeue_pair!(q)
        @show pos, d
        if pos ∈ seen
            continue
        else
            push!(seen, pos)
        end
        if pos == finish
            return d
        end
        for nei in neighbours(pos)
            if nei ∉ seen
                if nei ∉ keys(q)
                    enqueue!(q, nei => d + data[nei])
                else
                    q[nei] = min(q[nei], d + data[nei])
                end
            end
        end
    end
    return nothing
end

dijkstra(CartesianIndex(1, 1), CartesianIndex(size(data)...)) |> println