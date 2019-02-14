

function yelpHG(model::Model)

    h = Hypergraph{Real,Business,Vector{Review}}(0,0)
    businesses_ids = Dict{AbstractString,Business}()
    verticies_ids = Dict{Business,Int}()
    for business in values(model.businesses)
        push!(businesses_ids, business.id=>business)
        v = SimpleHypergraphs.add_vertex!(h)
        set_vertex_meta!(h,business,v)
        push!(verticies_ids, business=>v)
    end

    users_review = Dict{AbstractString, Dict{Int, Vector{Review}}}()
    for review in values(model.reviews)
        if haskey(businesses_ids,review.business)
            business = businesses_ids[review.business]
            vertex = verticies_ids[business]
            user = review.user

            if !haskey(users_review,user)
                users_review[user] = Dict{Int, Vector{Review}}()
            end


            if !haskey(users_review[user],vertex)
                d = Vector{Review}()
            else
                d = users_review[user][vertex]
            end

            push!(d,review)
            push!(users_review[user], vertex=>d)
        end
    end

    for ureview in values(users_review)

        for v in keys(ureview)

            set_hyperedge_meta!(h,ureview.second,e)
        end
        e = add_hyperedge!(h)

    end

    return h

end

function forecastNumberOfStar(h::Hypergraph)

    herr = 0
    for vertex in 1:size(h)[1]
        avg = 0.0
        treview = 0
        for edge in gethyperedges(h,vertex)
            for review in get_hyperedge_meta(h,edge)
                avg += review.stars
                treview+=1
            end

        end
        avg = avg/treview
        if abs(avg - get_vertex_meta(h,vertex).stars) > 1.0
            herr += 1
        end
    end

    g = SimpleGraph(TwoSectionView(h))
    gerr = 0
    for v1 in vertices(g)
        avg = 0.0
        for v2 in all_neighbors(g,v1)
            avg +=  get_vertex_meta(h,v2).stars
        end
        avg = avg/length(all_neighbors(g,v1))
        if abs(avg - get_vertex_meta(h,v1).stars) > 1.0
            gerr += 1
        end
    end

    return herr/size(h)[1],  gerr/size(h)[1]
end
