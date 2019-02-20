using Test
using HypergraphsYelp
using SimpleHypergraphs
using LightGraphs, SimpleWeightedGraphs



function forecastNumberOfStar(h::Hypergraph)
    herr = 0.0
    hupred = 0
    for vertex in 1:size(h)[1]

        if length(gethyperedges(h,vertex)) == 0
            hupred+=1
            continue
        end
        avgs = Float64[]

        for edge in gethyperedges(h,vertex)

            if length(getvertices(h,edge[1])) < 2
                continue
            end

            pavg = 0.0
            ptreview = 0

            for v2 in getvertices(h,edge[1])
                if v2 != vertex
                    pavg += get_vertex_meta(h,v2[1]).stars
                    ptreview+=1
                end
            end

            push!(avgs,pavg/ptreview)


        end
        if length(avgs) == 0
            hupred += 1
            continue
        end
        avg = sum(avgs)/length(avgs)

        herr+= abs(avg - get_vertex_meta(h,vertex).stars)
        #println("H ",vertex ," ",avg )
    end
    #t = TwoSectionView(h)
    #g = SimpleGraph(t)
    g = TwoSectionViewWeighted(h)
    gerr = 0.0
    gupred = 0
    for v1 in vertices(g)
        if length(all_neighbors(g,v1))==0
            gupred+=1
            continue
        end
        avg = 0.0
        weight = 0.0
        for v2 in all_neighbors(g,v1)
            avg += get_vertex_meta(h,v2).stars * g.weights[v1,v2]
            weight += g.weights[v1,v2]
            #println(v1,"-",v2,"=",g.weights[v1,v2])
        end
        avg = avg/weight
        gerr += abs(avg - get_vertex_meta(h,v1).stars)
        #println("G ",v1 ," ",avg)
    end


    #return herr,  gerr
    return herr/(size(h)[1] - hupred), (size(h)[1] - hupred),  gerr/(size(h)[1] - gupred), (size(h)[1] - gupred)
end

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



#amount of data to load for users and review
lines = 100

println("Loading data ..")

@time model = loadData("./data",lines)


#(outRead, outWrite) = redirect_stdout()
h = yelpHG(model)

t = TwoSectionView(h)
twosection_graph = LightGraphs.SimpleGraph(t)

println(size(h)," ----- ",LightGraphs.nv(twosection_graph),",",LightGraphs.ne(twosection_graph))

println(forecastNumberOfStar(h))


#close(outWrite)
#data = readavailable(outRead)
#logfile = open("task1.log", "a")
#write(logfile, data)
#close(outRead)
