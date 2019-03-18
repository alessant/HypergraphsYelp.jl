
struct Business
    id::Symbol
    name::Symbol
    city::Symbol
    state::Symbol
    lat::Float64
    lng::Float64
    stars::Float64
    reviewcount::Int
    categories::Vector{Symbol}
end


struct User
    id::Symbol
    reviewcount::Int
    totcompliment::Int
    avgstars::Float64
    friends::Vector{Symbol}
end

struct Review
    id::Symbol
    user::Symbol
    business::Symbol
    stars::Int
    date::DateTime
    useful::Int
    funny::Int
    cool::Int
end

struct Model
    businesses::Dict{Symbol,Business}
    users::Dict{Symbol,User}
    reviews::Dict{Symbol,Review}
end
