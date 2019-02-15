

function loadBusiness(io::IO, lines::Int)
    result = Dict{String,Business}()
    counter = 0

    while counter < lines && !eof(io)
        line = readline(io)
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
               json["categories"]!=nothing ? map(strip, split(json["categories"],",")) : Vector{String}()
         )
         push!(result,json["business_id"]=>b)

         counter += 1
    end
    return result
end


function loadUsers(io::IO, lines::Int)
    result = Dict{String,User}()
    counter = 0

    while counter < lines && !eof(io)
        line = readline(io)
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
            json["friends"]!=nothing ?  map(strip, split(json["friends"],",")) : Vector{String}()
        )
        push!(result,json["user_id"]=>b)

        counter += 1
    end
    return result
end


function loadReview(io::IO, lines::Int)
    result = Dict{String,Review}()
    counter = 0

    while counter < lines && !eof(io)
        line = readline(io)
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

        counter += 1
    end
    return result
end



"""
    path, is the directory with business.json, review.json, and user.json
"""
function loadData(path::AbstractString, lines::Int=typemax(Int))

    businesses = loadBusiness(open(string(path,Base.Filesystem.path_separator,"business.json"), "r"), typemax(Int))

    users = loadUsers(open(string(path,Base.Filesystem.path_separator,"user.json"), "r"), lines)

    reviews = loadReview(open(string(path,Base.Filesystem.path_separator,"review.json"), "r"), lines)

    return Model(businesses, users, reviews)
end
