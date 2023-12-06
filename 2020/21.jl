using Chain
using Pipe

struct Recipe
    ingredients::Vector{String}
    allergens::Vector{String}
end

struct Connection
    in_use::Int
    capacity::Int
end

function parseline(line)
    re_line = r"((?:\w+ )+)\(contains (\w+(?:, \w+)*)\)"
    m = match(re_line, line)
    ingredients = split(m[1])
    allergens = split(m[2], ", ")
    Recipe(ingredients, allergens)
end

data = readlines() .|> parseline


function get_safe_ingredients(data::Vector{Recipe})
    allergen_to_recipe = Dict()
    for r in data
        for al in r.allergens
            push!(get!(allergen_to_recipe, al, []), r)
        end
    end

    all_allergens = Set([
        al
        for r in data
        for al in r.allergens
    ])

    all_ingredients = Set([
        ing
        for r in data
        for ing in r.ingredients
    ])

    ingredients_with_potential_allergens = Set()
    for al in all_allergens
        al_related_ingredients = intersect([r.ingredients for r in allergen_to_recipe[al]]...)
        union!(ingredients_with_potential_allergens, al_related_ingredients)
    end

    safe_ingredients = setdiff(all_ingredients, ingredients_with_potential_allergens)

    safe_ingredients
end


function solve1(data::Vector{Recipe})
    safe_ingredients = get_safe_ingredients(data)

    sum(data) do r
        count(∈(safe_ingredients), r.ingredients)
    end
end

function make_pairs(matrix::Matrix{Int})
    n = size(matrix, 1)
    N = n
    k = 0
    pairs = Set()
    while k < N
        k += 1
        for (j, col) in enumerate(eachcol(matrix))
            if sum(col) == 1
                i = [i for (i, c) in enumerate(col) if c == 1][1]
                matrix[i, :] .= 0
                matrix[i, j] = 1
                push!(pairs, (i, j))

            end
        end

        for (i, row) in enumerate(eachrow(matrix))
            if sum(row) == 1
                j = [j for (j, r) in enumerate(row) if r == 1][1]
                matrix[:, j] .= 0
                matrix[i, j] = 1
                push!(pairs, (i, j))

            end
        end
    end
    sort(collect(pairs))
end


function solve2(data::Vector{Recipe})
    safe_ingredients = get_safe_ingredients(data)

    all_allergens = [
        al
        for r in data
        for al in r.allergens
    ] |> unique
    sort!(all_allergens)

    all_ingredients = Set([
        ing
        for r in data
        for ing in r.ingredients
    ])
    setdiff!(all_ingredients, safe_ingredients)


    allergen_to_recipe = Dict()
    for r in data
        for al in r.allergens
            push!(get!(allergen_to_recipe, al, []), r)
        end
    end

    ing_index = Dict([
        ing => i
        for (i, ing) in enumerate(all_ingredients)
    ])
    matrix = zeros(Int, length(all_allergens), length(all_ingredients))

    for (i, al) in enumerate(all_allergens)
        al_related_ingredients = intersect([r.ingredients for r in allergen_to_recipe[al]]...)
        for ing in al_related_ingredients
            matrix[i, ing_index[ing]] = 1
        end
    end

    ingredients = collect(all_ingredients)

    pairs = make_pairs(matrix)

    solution = []
    for (i, j) in pairs
        push!(solution, ingredients[j])
    end
    join(solution, ",")
end



data |> solve1 |> println
data |> solve2 |> println