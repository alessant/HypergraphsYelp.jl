__precompile__()
"""

"""
module HypergraphsYelp

using JSON
using SimpleHypergraphs
using LightGraphs
using PyPlot

export Business, User, Review
export Model, loadData
export plotBusinessByCategories, plotBusinessByCities, plotBusinessByStates, plotBusinessByStars
export plotUsersByReviewCount, plotUsersByFriendsCount,plotUsersByComplimentsCount
export yelpHG, forecastNumberOfStar

include("model.jl")
include("parser.jl")
include("analyzer.jl")
include("builder.jl")

 println("Loading data ..")
 @time model = loadData("data",1000)

# buildAnalysis("plots")

h = yelpHG(model)
println(forecastNumberOfStar(h))


end
