using Test
using HypergraphsYelp
using SimpleHypergraphs
using LightGraphs


#amount of data to load for users and review
lines = 100

println("Loading data ..")

@time model = loadData("./data",lines)


#(outRead, outWrite) = redirect_stdout()
h = yelpHG(model)

review_star_map = buildReviewsByStars(model)

println(keys(review_star_map))

#close(outWrite)
#data = readavailable(outRead)
#logfile = open("task1.log", "a")
#write(logfile, data)
#close(outRead)
"""
function buildReviewsByStars(model::Model)

    result = Dict{Int,Array{Review}}()
    for review in values(model.reviews)

        if !haskey(result, review.stars)
            push!(result, review.stars=>Vector{Review}())
        end
        push!(result[review.stars],review)
    end
    result
end
"""
