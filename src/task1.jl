using Test
using HypergraphsYelp
using SimpleHypergraphs
using LightGraphs

(outRead, outWrite) = redirect_stdout()

#amount of data to load for users and review
lines = 100

println("Loading data ..")
@time model = loadData("./data",lines)


h = yelpHG(model)

t = TwoSectionView(h)
twosection_graph = LightGraphs.SimpleGraph(t)

println(size(h)," ----- ",LightGraphs.nv(twosection_graph),",",LightGraphs.ne(twosection_graph))

println(forecastNumberOfStar(h))


close(outWrite)
data = readavailable(outRead)
logfile = open("task1.log", "a")
write(logfile, data)
close(outRead)
