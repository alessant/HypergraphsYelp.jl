

function yelpHG(model::Model)

    h = Hypergraph{Float64,Business,Array{Review,1}}(0,0)

    businesses_ids = Dict{Symbol,Business}()
    verticies_ids = Dict{Business,Int}()
    for business in values(model.businesses)
        push!(businesses_ids, business.id=>business)
        v = SimpleHypergraphs.add_vertex!(h)
    #    println("BUSINESS MAP ",business.id," ",v)
        set_vertex_meta!(h,business,v)
        push!(verticies_ids, business=>v)
    end

    users_review = Dict{Symbol, Dict{Int, Array{Review,1}}}()
    for review in values(model.reviews)
        if haskey(businesses_ids,review.business)#IF I DON'T LOAD ALL BUSINESS

            business = businesses_ids[review.business]
            vertex = verticies_ids[business]

            user = review.user

            if !haskey(users_review,user)
                push!(users_review, user=>Dict{Int, Array{Review,1}}())
            end


            if !haskey(users_review[user],vertex)
                d = Array{Review,1}()
            else
                d = users_review[user][vertex]
            end

            push!(d,review)
            push!(users_review[user], vertex=>d)
        end
    end

    for ureview in values(users_review)
        meta = Array{Review,1}()
        for reviews in values(ureview)
            for review in reviews
                push!(meta, review)
            end
        end
        e = add_hyperedge!(h)

        verticies = Dict{Int,Float64}()
        for v in keys(ureview)
            h[v,e] = 0
        end
        set_hyperedge_meta!(h,meta,e)
    end

    return h

end
