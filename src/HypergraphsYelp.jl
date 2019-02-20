__precompile__()
"""

"""
module HypergraphsYelp

using JSON
using SimpleHypergraphs
using LightGraphs, SimpleWeightedGraphs
using PyPlot
using GraphPlot
using Juno
using Dates



export Business, User, Review, Model
export loadData
export plotBusinessByCategories, plotBusinessByCities, plotBusinessByStates, plotBusinessByStars
export plotUsersByReviewCount, plotUsersByFriendsCount,plotUsersByComplimentsCount
export buildAnalysis
export yelpHG, forecastNumberOfStar, buildReviewsByStars

include("model.jl")
include("parser.jl")
include("analyzer.jl")
include("builder.jl")


end
