__precompile__()
"""

"""
module HypergraphsYelp

using JSON
using SimpleHypergraphs
using PyPlot

export Business, User, Review
export Model, loadData
export plotBusinessByCategories, plotBusinessByCities, plotBusinessByStates, plotBusinessByStars
export plotUsersByReviewCount, plotUsersByFriendsCount,plotUsersByComplimentsCount

include("model.jl")
include("parser.jl")
include("analyzer.jl")
include("builder.jl")

@time model = loadData("data")
plotout= "plots/"
plotBusinessByCategories(model)
savefig(string(plotout,"categories.png"))

plotBusinessByCities(model)
savefig(string(plotout,"cities.png"))

plotBusinessByStates(model)
savefig(string(plotout,"states.png"))

plotBusinessByStars(model)
savefig(string(plotout,"stars.png"))

plotUsersByReviewCount(model)
savefig(string(plotout,"reviewcount.png"))

plotUsersByFriendsCount(model)
savefig(string(plotout,"friends.png"))

plotUsersByComplimentsCount(model)
savefig(string(plotout,"compliments.png"))

end
#
# using PyPlot
# # use x = linspace(0,2*pi,1000) in Julia 0.6
# x = range(0; stop=2*pi, length=1000); y = sin.(3 * x + 4 * cos.(2 * x));
# p = plot(x, y, color="red", linewidth=2.0, linestyle="--")
# title("A sinusoidally modulated sinusoid")
# gcf()
