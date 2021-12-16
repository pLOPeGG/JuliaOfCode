using DataStructures

const data = parse.(Int, reduce(hcat, collect.(readlines())))

neighbours(pos; expand = 1) =
    filter([
        CartesianIndex(pos.I .- n)
        for n ∈ ((-1, 0), (1, 0), (0, -1), (0, 1))
    ]) do I
        1 <= I.I[1] <= size(data, 1) * expand && 1 <= I.I[2] <= size(data, 2) * expand
    end

divmod1(x, y) = (div(x, y) - (rem(x, y) == 0 ? 1 : 0), mod1(x, y))

function get_val(data, pos::CartesianIndex)
    qx, rx = divmod1(pos[1], size(data, 1))
    qy, ry = divmod1(pos[2], size(data, 2))

    reduced_pos = CartesianIndex(rx, ry)
    mod1(data[reduced_pos] + qx + qy, 9)
end

function dijkstra(start, finish; expand = 1)
    q = PriorityQueue{CartesianIndex,Int}(Base.Order.Forward)
    seen = Set{CartesianIndex}()

    enqueue!(q, start => 0)

    while !isempty(q)
        pos, d = dequeue_pair!(q)
        if pos ∈ seen
            continue
        else
            push!(seen, pos)
        end
        if pos == finish
            return d
        end
        for nei in neighbours(pos; expand)
            if nei ∉ seen
                if nei ∉ keys(q)
                    enqueue!(q, nei => d + get_val(data, nei))
                else
                    q[nei] = min(q[nei], d + get_val(data, nei))
                end
            end
        end
    end
    return nothing
end

# Part One
dijkstra(CartesianIndex(1, 1), CartesianIndex(size(data)...)) |> println

# Part Two
dijkstra(CartesianIndex(1, 1), CartesianIndex(size(data)...) * 5; expand = 5) |> println
