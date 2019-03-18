

function loadBusiness(io::IO, business_filter::Dict{Symbol,Symbol}, lines::Int)



    result = Dict{Symbol,Business}()
    counter = 0

    while counter < lines && !eof(io)
        line = readline(io)
        json = JSON.parse(line)

        id = Symbol(json["business_id"])

        if haskey(business_filter,id)

            b = Business(
                   id,
                   Symbol(json["name"]),
                   Symbol(json["city"]),
                   Symbol(json["state"]),
                   json["latitude"],
                   json["longitude"],
                   json["stars"],
                   json["review_count"],
                   Vector{Symbol}()
                   #json["categories"]!=nothing ? Symbol.(map(strip, split(json["categories"],","))) : Symbol[]
             )
             push!(b.categories,  business_filter[id])
            result[id] = b
         end
         counter += 1
    end

    return result
end


function loadUsers(io::IO, lines::Int)
    result = Dict{Symbol,User}()
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

        id = Symbol(json["user_id"])
        b = User(
            id,
            json["review_count"],
            totcompliments,
            json["average_stars"],
            json["friends"]!=nothing ?  Symbol.(map(strip, split(json["friends"],","))) : Symbol[]
        )
        result[id]=b
        counter += 1
    end
    return result
end


function loadReview(io::IO, business_filter::Dict{Symbol,Symbol} ,lines::Int)::Dict{Symbol,Review}

    result = Dict{Symbol,Review}()
    counter = 0

    while counter < lines && !eof(io)
        line = codeunits(readline(io))
        a1 = view(line,1:(nth(',',line,7)-1))
        a2 = view(line,nth(',',line,1,true):length(line))

        json = JSON.parse(String(vcat(a1,a2)))
        idb = Symbol(json["business_id"])
        if haskey(business_filter,idb)
            id = Symbol(json["review_id"])
            b = Review(
                id,
                Symbol(json["user_id"]),
                idb,
                json["stars"],
                DateTime(json["date"],dateformat"yyyy-mm-dd HH:MM:SS"),
                json["useful"],
                json["funny"],
                json["cool"]
            )

            result[id]=b
        end
        counter += 1
    end
    return result
end

function nth(what::Char,s::AbstractVector{UInt8},n::Int,reverse = false)
    c = UInt8(what)
    count = 0
    for ix::Int in (reverse ? (length(s):-1:1) : (1:length(s)) )
        (s[ix] == c) && (count += 1)
        count >= n && return ix
    end
    return -1
end


"""
    path, is the directory with business.json, review.json, and user.json
"""
function loadData(path::AbstractString, lines::Int=typemax(Int))

    business_filter = Dict{Symbol,Symbol}()
    filterio =  open(string(path,Base.Filesystem.path_separator,"restaurant_category_map.txt"), "r")
    line = readline(filterio)
    while !eof(filterio)
        line = readline(filterio)
        s = split(line,",")
        push!(business_filter,Symbol(s[1])=>Symbol(s[2]))
    end

    businesses = loadBusiness(open(string(path,Base.Filesystem.path_separator,"business.json"), "r"),business_filter, typemax(Int))

    users = loadUsers(open(string(path,Base.Filesystem.path_separator,"user.json"), "r"), lines)

    reviews = loadReview(open(string(path,Base.Filesystem.path_separator,"review.json"), "r"),business_filter, lines)

    return Model(businesses, users, reviews)
end
