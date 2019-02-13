
struct Model
    businesses::Dict{String,Business}
    users::Dict{String,User}
    reviews::Dict{String,Review}
end
function loadBusiness(path::String)
    result = Dict{String,Business}()
    lines = readlines(path)
    for line in lines
        json = JSON.parse(line)
        b = Business(
            json["business_id"],
            json["name"],
            json["city"],
            json["state"],
            json["latitude"],
            json["longitude"],
            json["stars"],
            json["review_count"],
            json["categories"]!=nothing ? split(json["categories"],",") : Vector{String}()
        )
        push!(result,json["business_id"]=>b)
    end
    return result
end
function loadUsers(path::String)
    result = Dict{String,User}()
    lines = readlines(path)
    for line in lines
        json = JSON.parse(line)

        totcompliments = 0
        totcompliments+=
            json["compliment_hot"] +
            json["compliment_more"] +
            json["compliment_profile"] +
            json["compliment_cute"] +
            json["compliment_list"] +
            json["compliment_note"] +
            json["compliment_plain"] +
            json["compliment_cool"] +
            json["compliment_funny"] +
            json["compliment_writer"] +
            json["compliment_photos"]

        b = User(
            json["user_id"],
            json["name"],
            json["review_count"],
            totcompliments,
            json["average_stars"],
            json["friends"]!=nothing ? split(json["friends"],",") : Vector{String}()
        )
        push!(result,json["user_id"]=>b)
    end
    return result
end


function loadReview(path::String)
    result = Dict{String,Review}()
    lines = readlines(path)
    for line in lines
        json = JSON.parse(line)
        b = Review(
            json["review_id"],
            json["user_id"],
            json["business_id"],
            json["stars"],
            json["date"],
            json["useful"],
            json["funny"],
            json["cool"]
        )
        push!(result,json["review_id"]=>b)
    end
    return result
end


"""
    path, is the directory with business.json, review.json, and user.json
"""
function loadData(path::AbstractString)

    businesses = loadBusiness(string(path,Base.Filesystem.path_separator,"business.json"))

    users = loadUsers(string(path,Base.Filesystem.path_separator,"user.json"))

    reviews = loadReview(string(path,Base.Filesystem.path_separator,"review.json"))

    return Model(businesses, users, reviews)
end
