using Test
using  HypergraphsYelp
using SimpleHypergraphs
using LightGraphs, SimpleWeightedGraphs
using Random


function TwoSectionViewWeighted(h::Hypergraph)

    g = SimpleWeightedGraph(size(h)[1])

    edges = Dict{Pair{Int,Int},Int}()

    hes = Set{Int}()
    for v in 1:size(h)[1]
        for he in keys(h.v2he[v])
            union!(hes, he)
        end
    end
    for he in values(hes)
        for v1 in keys(h.he2v[he])
            for v2 in keys(h.he2v[he])
                if v1 < v2
                    if haskey(edges, v1=>v2)
                        edges[v1=>v2] = (edges[v1=>v2][1]+1)
                    else
                        push!(edges,(v1=>v2)=>1)
                    end
                end
            end
        end
    end
    for e in keys(edges)
        add_edge!(g, e[1], e[2], edges[e])
    end
    g
end

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

function computeHyperedgeSizeDistribution(h::Hypergraph)
    dims = Dict{Int, Int}()

    for he in 1:size(h)[2]
        if haskey(dims, he) continue end
        push!(dims, he => length(getvertices(h,he)))
    end

    result = Dict{Int, Int}()
    for value in values(dims)
        n = haskey(result, value) ? result[value]+1 : 1
        push!(result, value => n)
    end
    result
end
function computeDegreeDistribution(g::SimpleWeightedGraph)

    result = Dict{Int, Int}()
    for v in vertices(g)
        value = length(neighbors(g,v))
        n = haskey(result, value) ? result[value]+1 : 1
        push!(result, value => n)
    end
    result
end


function computeVertexLabel(h::Hypergraph, v::Int64, lV::Dict{Int64,Int64}, lH::Dict{Int64,Int64}, rng::MersenneTwister)

    vh = gethyperedges(h,v)
    vL = Dict{Int64,Int64}()

    max = 0
    maxL = Set{Int64}()

    for e in shuffle!(rng, collect(keys(vh)))
        l = lH[e]
        if !haskey(vL, l) push!(vL,l=>0) end
        push!(vL, l=>vL[l] + (length(getvertices(h,e))))

        if vL[l] == max
            push!(maxL,l)
        elseif vL[l] > max
            max = vL[l]
            maxL = Set{Int64}()
            push!(maxL,l)
        end

    end
    if in(lV[v],maxL)
        return lV[v]
    end
    return collect(maxL)[1]
end

function computeEdgeLabel(h::Hypergraph, e::Int64, lV::Dict{Int64,Int64}, rng::MersenneTwister)
    ve = getvertices(h,e)
    eL = Dict{Int64,Int64}()

    max = 0
    maxL = -1

    for v in shuffle!(rng, collect(keys(ve)))
        l = lV[v]
        if !haskey(eL, l) push!(eL,l=>0) end
        push!(eL, l=>eL[l]+1)

        if eL[l] > max
            max = eL[l]
            maxL = l
        end
    end

    return maxL
end



function label_propagation_h(h::Hypergraph)
    rng = MersenneTwister(1234)

    lV = Dict{Int64,Int64}()
    lH = Dict{Int64,Int64}()

    for v in 1:size(h)[1]
        push!(lV,v=>v)
    end

    stop = false
    iter = 0
    edges = Array{Int64}(undef, size(h)[2])
    for ie in 1:size(h)[2]
        edges[ie] = ie
    end
    vertices = Array{Int64}(undef, size(h)[1])
    for iv in 1:size(h)[1]
        vertices[iv] = iv
    end


    while !stop && iter < 100
        stop = true
        shuffle!(rng,edges)
        for e in edges
            l = computeEdgeLabel(h,e,lV,rng)
            push!(lH, e=>l)
        end
        shuffle!(rng,vertices)
        for v in vertices
            l = computeVertexLabel(h, v, lV, lH, rng)

            if l != lV[v]
                stop = false
                push!(lV,v=>l)
            end

        end
        iter+=1
    end

    println("H LP iter: ",iter)

    labels = Array{Int64}(undef, size(h)[1])
    for i in 1:size(h)[1]
        labels[i] = lV[i]
    end
    return labels

end

function computeEdgesLabelByLP(h::Hypergraph, lV::Dict{Int64,Int64})

    g = SimpleWeightedGraph(size(h)[2])

    for he1 in 1:size(h)[2]
        for he2 in 1:size(h)[2]
            weight = 0
            for v1 in getvertices(h,he1)
                for v2 in getvertices(h,he2)
                    weight +=1
                end
            end
            weight/=2
            if weight != 0
                add_edge!(g, he1, he2, weight)
            end
        end

    end

    lp = LightGraphs.label_propagation(g)
    println("LP")
    println(lp)

end


function label_propagation_h2(h::Hypergraph)
    rng = MersenneTwister(1234)

    lV = Dict{Int64,Int64}()
    lH = Dict{Int64,Int64}()

    for v in 1:size(h)[1]
        push!(lV,v=>v)
    end

    stop = false
    iter = 0
    edges = Array{Int64}(undef, size(h)[2])
    for ie in 1:size(h)[2]
        edges[ie] = ie
    end
    vertices = Array{Int64}(undef, size(h)[1])
    for iv in 1:size(h)[1]
        vertices[iv] = iv
    end

    computeEdgesLabelByLP(h,lV)

    # while !stop && iter < 100
    #     stop = true
    #     shuffle!(rng,edges)
    #     for e in edges
    #         l = computeEdgesLabelByLP(h,lV)
    #         push!(lH, e=>l)
    #     end
    #     shuffle!(rng,vertices)
    #     for v in vertices
    #         l = computeVertexLabel(h, v, lV, lH, rng)
    #
    #         if l != lV[v]
    #             stop = false
    #             push!(lV,v=>l)
    #         end
    #
    #     end
    #     iter+=1
    # end
    #
    # println("H LP iter: ",iter)
    #
    # labels = Array{Int64}(undef, size(h)[1])
    # for i in 1:size(h)[1]
    #     labels[i] = lV[i]
    # end
    # return labels

end

function computePartitioingByCategories(h::Hypergraph)

    map = Dict{Symbol,Int64}()
    p = Int64[]
    cindex = 1
    for v in 1:size(h)[1]
        b = get_vertex_meta(h,v)
        c = length(b.categories) == 0 ?  Symbol("default") : b.categories[1]
        if !haskey(map, c)
            push!(map,c=>cindex)
            cindex+=1
        end
        push!(p,map[c])
    end
     p

end

function accuracy(p1::Array{Int64}, p2::Array{Int64})
    n = length(p1)
    e = 0
    for i in 1:n-1
        for j in i+1:n
            if (p1[i] == p1[j] && p2[i] != p2[j]) || (p1[i] != p1[j] && p2[i] == p2[j])
                e+=1
            end
        end
    end

    return (1 - (2 * e / (n * (n-1)) ))
end

function computeTask3(model1::Model, model2::Model, name1::String, name2::String)

    h12 = yelpHG(model1)
    h5 = yelpHG(model2)


    h12 = cleanHG(h12)
    h5 = cleanHG(h5)

    g12 = TwoSectionViewWeighted(h12)
    g5 = TwoSectionViewWeighted(h5)

    println("G",name1," (", LightGraphs.nv(g12),",",LightGraphs.ne(g12),")")
    println("G",name2," (", LightGraphs.nv(g5),",",LightGraphs.ne(g5),")")
    println("H",name1," ", size(h12))
    println("G",name2," ", size(h5))


    distributionh12 = computeHyperedgeSizeDistribution(h12)
    distributionh5 = computeHyperedgeSizeDistribution(h5)

    distributiong12 = computeDegreeDistribution(g12)
    distributiong5 = computeDegreeDistribution(g5)

    println("Degree Distribution G",name1)
    for k in keys(distributiong12)
        print(k,",")
    end
    println("")
    for v in values(distributiong12)
        print(v,",")
    end
    println("")
    println("Degree Distribution G",name2)
    for k in keys(distributiong5)
        print(k,",")
    end
    println("")
    for v in values(distributiong5)
        print(v,",")
    end
    println("")
    println("Hyperedges Size Distribution H",name1)

    for k in keys(distributionh12)
        print(k,",")
    end
    println("")
    for v in values(distributionh12)
        print(v,",")
    end
    println("")
    println("Hyperedges Size Distribution H",name2)

    for k in keys(distributionh5)
        print(k,",")
    end
    println("")
    for v in values(distributionh5)
        print(v,",")
    end
    println("")


    lp12 = LightGraphs.label_propagation(g12)
    lp5 = LightGraphs.label_propagation(g5)
    lph12 = label_propagation_h(h12)
    lph5 = label_propagation_h(h5)
    pbyc12 = computePartitioingByCategories(h12)
    pbyc5 = computePartitioingByCategories(h5)



    println("G",name1," Modularity ",LightGraphs.modularity(g12,lp12[1]))
    println("G",name2," Modularity ",LightGraphs.modularity(g5,lp5[1]))

    println("G",name1," CC ",LightGraphs.global_clustering_coefficient(g12))
    println("G",name2," CC ",LightGraphs.global_clustering_coefficient(g5))

    println("G",name1," T ",sum(LightGraphs.triangles(g12))/3)
    println("G",name2," T ",sum(LightGraphs.triangles(g5))/3)


    println("NMI C vs G",name1," ", nmi(lp12[1],pbyc12))
    println("NMI C vs G",name2," ", nmi(lp5[1],pbyc5))
    println("NMI C vs H",name1," ", nmi(lph12,pbyc12))
    println("NMI C vs H",name2," ", nmi(lph5,pbyc5))
    println("NMI G",name1," vs G",name2," ", nmi(lp12[1],lp5[1]))
    println("NMI G",name1," vs H",name1," ", nmi(lp12[1],lph12))
    println("NMI G",name2," vs H",name2," ", nmi(lp12[1],lph5))
    println("NMI G",name2," vs H",name1," ", nmi(lp5[1],lph12))
    println("NMI G",name2," vs H",name2," ", nmi(lp5[1],lph5))
    println("NMI H",name1," vs H",name2," ", nmi(lph12,lph5))

    println("Accuracy C vs G",name1," ", accuracy(lp12[1],pbyc12))
    println("Accuracy C vs G",name2," ", accuracy(lp5[1],pbyc5))
    println("Accuracy C vs H",name1," ", accuracy(lph12,pbyc12))
    println("Accuracy C vs H",name2," ", accuracy(lph5,pbyc5))
    println("Accuracy G",name1," vs H",name1," ", accuracy(lp12[1],lph12))
    println("Accuracy G",name2," vs H",name2," ", accuracy(lp5[1],lph5))



end


function computeTask3ALL(model1::Model)

    h12 = yelpHG(model1)
    h12 = cleanHG(h12)

    g12 = TwoSectionViewWeighted(h12)
    println("G (", LightGraphs.nv(g12),",",LightGraphs.ne(g12),")")

    println("H ", size(h12))



    distributionh12 = computeHyperedgeSizeDistribution(h12)
    distributiong12 = computeDegreeDistribution(g12)


    println("Degree Distribution G")
    for k in keys(distributiong12)
        print(k,",")
    end
    println("")
    for v in values(distributiong12)
        print(v,",")
    end

    println("")
    println("Hyperedges Size Distribution H")

    for k in keys(distributionh12)
        print(k,",")
    end
    println("")
    for v in values(distributionh12)
        print(v,",")
    end

    println("")


    lp12 = LightGraphs.label_propagation(g12)

    lph12 = label_propagation_h(h12)

    pbyc12 = computePartitioingByCategories(h12)


    println("G Modularity ",LightGraphs.modularity(g12,lp12[1]))
    println("G CC ",LightGraphs.global_clustering_coefficient(g12))
    println("G T ",sum(LightGraphs.triangles(g12))/3)



    println("NMI C vs G ", nmi(lp12[1],pbyc12))
    println("NMI C vs H ", nmi(lph12,pbyc12))


    println("Accuracy C vs G ", accuracy(lp12[1],pbyc12))
    println("Accuracy C vs H ", accuracy(lph12,pbyc12))


end

rng = MersenneTwister(1234);
#amount of data to load for users and review
lines = 100000

println("Loading data ..")

@time model = loadData("./data",100000)




review_star_map = buildReviewsByStars(model)

nr = length(review_star_map[2])
println("Loaded reviews: ",nr)
for n in review_star_map
    println(n[1]," ",length(n[2]))
end

# for star1 in 1:5
#     for star2 in 1:5
#         if star1 < star2
#             println("Compare: ", star1," ",star2, " -------------------------------------------------")
#
#             reviews1 = Dict{Symbol,Review}()
#
#             for i in 1:nr
#                 r = review_star_map[star1][i]
#                 push!(reviews1,r.id=>r)
#             end
#
#             model1 = Model(model.businesses,model.users,reviews1)
#
#             shuffle!(rng, review_star_map[star2])
#
#             reviews2 = Dict{Symbol,Review}()
#             for i in 1:nr
#                 r = review_star_map[star2][i]
#                 push!(reviews2,r.id=>r)
#             end
#
#             model2 = Model(model.businesses,model.users,reviews2)
#
#             computeTask3(model1,model2,string(star1),string(star2))
#
#             println("-------------------------------------------------------------------------------")
#         end
#     end
# end

 # model = Model(model.businesses,model.users,model.reviews)
 # computeTask3ALL(model)


 for star1 in 1:2
     for star2 in 1:2
         if star1 < star2
             println("Compare: ", star1," ",star2, " -------------------------------------------------")

             reviews1 = Dict{Symbol,Review}()

             for i in 1:nr
                 r = review_star_map[star1][i]
                 push!(reviews1,r.id=>r)
             end

             model1 = Model(model.businesses,model.users,reviews1)

             shuffle!(rng, review_star_map[star2])

             reviews2 = Dict{Symbol,Review}()
             for i in 1:nr
                 r = review_star_map[star2][i]
                 push!(reviews2,r.id=>r)
             end

             model2 = Model(model.businesses,model.users,reviews2)

             h = yelpHG(model1)
             h = cleanHG(h)
             println("H ", size(h))
            label_propagation_h2(h)

             println("-------------------------------------------------------------------------------")
         end
     end
 end
