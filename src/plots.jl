using Test
using HypergraphsYelp
using SimpleHypergraphs
using LightGraphs

println("Loading data ..")
@time model = loadData("./data",100)

buildAnalysis("plots",model)
