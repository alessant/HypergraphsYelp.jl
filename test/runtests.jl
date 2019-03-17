using Test
using HypergraphsYelp
using SimpleHypergraphs
using LightGraphs
using Dates


const testdir = dirname(@__FILE__)


tests = [
    #"",
]

b1 = Business(:a,:r1,:napoli,:italy,0.0,0.0,2.0,0,Symbol[])
b2 = Business(:b,:r2,:avellino,:italy,0.0,0.0,3.0,0,Symbol[])
b3 = Business(:c,:r3,:caserta,:italy,0.0,0.0,3.0,0,Symbol[])
b4 = Business(:d,:r4,:napoli,:italy,0.0,0.0,2.5,0,Symbol[])
b5 = Business(:e,:r5,:avellino,:italy,0.0,0.0,2.0,0,Symbol[])


u1 = User(:a,0,0,0,Symbol[])
u2 = User(:b,0,0,0,Symbol[])

r1 = Review(:a,u1.id,b1.id,3.0,now(),0,0,0)
r2 = Review(:b,u1.id,b2.id,3.0,now(),0,0,0)
r3 = Review(:c,u1.id,b3.id,3.0,now(),0,0,0)
r4 = Review(:d,u1.id,b4.id,3.0,now(),0,0,0)

r5 = Review(:e,u2.id,b1.id,2.0,now(),0,0,0)
r6 = Review(:f,u2.id,b4.id,2.0,now(),0,0,0)
r7 = Review(:g,u2.id,b5.id,2.0,now(),0,0,0)


businesses = Dict{Symbol,Business}()
users = Dict{Symbol,User}()
reviews = Dict{Symbol,Review}()

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
