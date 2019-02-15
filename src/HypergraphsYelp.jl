__precompile__()
"""

"""
module HypergraphsYelp

using JSON
using SimpleHypergraphs, SimpleWeightedGraphs
using LightGraphs
using PyPlot
using GraphPlot
using Juno



export Business, User, Review, Model
export loadData
export plotBusinessByCategories, plotBusinessByCities, plotBusinessByStates, plotBusinessByStars
export plotUsersByReviewCount, plotUsersByFriendsCount,plotUsersByComplimentsCount
export yelpHG, forecastNumberOfStar

include("model.jl")
include("parser.jl")
include("analyzer.jl")
include("builder.jl")




end
