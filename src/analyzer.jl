
function plotBusinessByCategories(model::Model)

    data = Dict{String,Int64}()
    maxs = Dict{String,Int64}()

    for business in values(model.businesses)
        for category in business.categories
            n = get(data, category, 0)
            push!(data,category=>(n+1))
        end
    end

    sorted = sort(collect(data),by= x -> x.second,rev=true)
    first = sorted[1:21]
    #println(first)
    ckeys = collect(keys(data))

    indexs = Int[]
    names = String[]
    j = 1
    for k in first
         i = findall(x->x==k.first,ckeys)

         push!(indexs,i[1])
         push!(names,ckeys[i[1]])

         j+=1
    end

    #p = pie(collect(values(data)))#collect(1:length(keys(data))),
    clf()
    title("Categories Distribution")
    xticks(indexs,names,rotation="vertical")
    return  plot(collect(1:length(keys(data))),collect(values(data)))



end

function plotBusinessByCities(model::Model)

    data = Dict{String,Int64}()

    for business in values(model.businesses)
        n = get(data, business.city, 0)
        push!(data,business.city=>(n+1))
    end

    sorted = sort(collect(data),by= x -> x.second,rev=true)
    first = sorted[1:21]
    ckeys = collect(keys(data))
    indexs = Int[]
    names = String[]
    for k in first
         i = findall(x->x==k.first,ckeys)
         push!(indexs,i[1])
         push!(names,ckeys[i[1]])
    end

    clf()
    title("Cities Distribution")
    xticks(indexs,names,rotation="vertical")
    return  plot(collect(1:length(keys(data))),collect(values(data)))
end


function plotBusinessByStates(model::Model)

    data = Dict{String,Int64}()

    for business in values(model.businesses)
        n = get(data, business.state, 0)
        push!(data,business.state=>(n+1))
    end
    sorted = sort(collect(data),by= x -> x.second,rev=true)
    first = sorted[1:21]
    ckeys = collect(keys(data))
    indexs = Int[]
    names = String[]
    for k in first
         i = findall(x->x==k.first,ckeys)
         push!(indexs,i[1])
         push!(names,ckeys[i[1]])
    end

    clf()
    title("States Distribution")
    xticks(indexs,names,rotation="vertical")
    return  bar(collect(1:length(keys(data))),collect(values(data)))
end


function plotBusinessByStars(model::Model)

    #data = Dict{String,Int64}()
    data = Real[]

    for business in  values(model.businesses)
        #n = get(data, business.stars, 0)
        push!(data,business.stars)
    end

    clf()
    title("Stars Distribution")

    return  hist(data, bins=[1,2,3,4,5])
end


function plotUsersByReviewCount(model::Model)

    #data = Dict{String,Int64}()
    data = Int[]

    for user in values(model.users)
        #n = get(data, user.reviewcount, 0)
        push!(data, user.reviewcount)
    end

    clf()
    title("Review count Distribution")
    return  hist(data)
end

function plotUsersByFriendsCount(model::Model)

    data = Int[]

    for user in values(model.users)
        #n = get(data, user.reviewcount, 0)
        push!(data, user.friends)
    end

    clf()
    title("Friends count Distribution")
    return  hist(data)
end


function plotUsersByComplimentsCount(model::Model)

    data = Int[]

    for user in values(model.users)
        #n = get(data, user.reviewcount, 0)
        push!(data, user.totcompliment)
    end

    clf()
    title("Compliments count Distribution")
    return  hist(data)
end

function plotReviewByDate(model::Model)

    data = Dict{String,Int64}()

    for review in model.review
        n = get(data, review.date, 0)
        push!(data, review.date=>(n+1))
    end
end
