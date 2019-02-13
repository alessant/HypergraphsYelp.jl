__precompile__()
"""

"""
module HypergraphsYelp

using JSON
using SimpleHypergraphs
using Plots
using PyPlot
using PyCall

export Business, User, Review
export Model, loadData

include("model.jl")
include("parser.jl")
include("analyzer.jl")
include("builder.jl")

pyplot()
@time model = loadData("data")

end
