
function plotBusinessByCategories(model::Model)

    data = Dict{String,Int64}()

    for business in model.businesses
        for category in business.categories
            n = get(data, category, 0)
            push!(data,category=>(n+1)
        end
    end


end

function plotBusinessByCity(model::Model)

    data = Dict{String,Int64}()

    for business in model.businesses
        n = get(data, business.city, 0)
        push!(data,business.city=>(n+1)
    end
end


function plotBusinessBySate(model::Model)

    data = Dict{String,Int64}()

    for business in model.businesses
        n = get(data, business.state, 0)
        push!(data,business.state=>(n+1)
    end
end


function plotBusinessByStars(model::Model)

    data = Dict{String,Int64}()

    for business in model.businesses
        n = get(data, business.stars, 0)
        push!(data,business.stars=>(n+1)
    end
end


function plotUsersByReviewCount(model::Model)

    data = Dict{String,Int64}()

    for user in model.users
        n = get(data, user.reviewcount, 0)
        push!(data, user.reviewcount=>(n+1)
    end
end

function plotUsersByFriendsCount(model::Model)

    data = Dict{String,Int64}()

    for user in model.users
        n = get(data, length(user.firends), 0)
        push!(data, length(user.firends)=>(n+1)
    end
end


function plotUsersByComplimentsCount(model::Model)

    data = Dict{String,Int64}()

    for user in model.users
        n = get(data, user.totcompliment, 0)
        push!(data, user.totcompliment=>(n+1)
    end
end

function plotReviewByDate(model::Model)

    data = Dict{String,Int64}()

    for review in model.review
        n = get(data, review.date, 0)
        push!(data, review.date=>(n+1)
    end
end
