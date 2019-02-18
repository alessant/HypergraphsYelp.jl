using Test
using HypergraphsYelp
using SimpleHypergraphs
using LightGraphs



const testdir = dirname(@__FILE__)


tests = [
    #"",
]

b1 = Business("1","r1","napoli","italy",0.0,0.0,2.0,0,Array{AbstractString,1}())
b2 = Business("2","r2","avellino","italy",0.0,0.0,3.0,0,Array{AbstractString,1}())
b3 = Business("3","r3","caserta","italy",0.0,0.0,3.0,0,Array{AbstractString,1}())
b4 = Business("4","r4","napoli","italy",0.0,0.0,2.5,0,Array{AbstractString,1}())
b5 = Business("5","r5","avellino","italy",0.0,0.0,2.0,0,Array{AbstractString,1}())


u1 = User("1","bob",0,0,0,Array{AbstractString,1}())
u2 = User("2","alice",0,0,0,Array{AbstractString,1}())

r1 = Review("1",u1.id,b1.id,3.0,"",0,0,0)
r2 = Review("2",u1.id,b2.id,3.0,"",0,0,0)
r3 = Review("3",u1.id,b3.id,3.0,"",0,0,0)
r4 = Review("4",u1.id,b4.id,3.0,"",0,0,0)

r5 = Review("5",u2.id,b1.id,2.0,"",0,0,0)
r6 = Review("6",u2.id,b4.id,2.0,"",0,0,0)
r7 = Review("7",u2.id,b5.id,2.0,"",0,0,0)


businesses = Dict{String,Business}()
users = Dict{String,User}()
reviews = Dict{String,Review}()

push!(businesses,b1.id=>b1)
push!(businesses,b2.id=>b2)
push!(businesses,b3.id=>b3)
push!(businesses,b4.id=>b4)
push!(businesses,b5.id=>b5)

push!(users,u1.id=>u1)
push!(users,u2.id=>u2)

push!(reviews,r1.id=>r1)
push!(reviews,r2.id=>r2)
push!(reviews,r3.id=>r3)
push!(reviews,r4.id=>r4)
push!(reviews,r5.id=>r5)
push!(reviews,r6.id=>r6)
push!(reviews,r7.id=>r7)

model = Model(businesses,users,reviews)

h = yelpHG(model)

t = TwoSectionView(h)
twosection_graph = LightGraphs.SimpleGraph(t)

println(size(h)," ----- ",LightGraphs.nv(twosection_graph),",",LightGraphs.ne(twosection_graph))

println(forecastNumberOfStar(h))
