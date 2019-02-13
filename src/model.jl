
struct Business
    id::AbstractString
    name::AbstractString
    city::AbstractString
    state::AbstractString
    lat::Real
    lng::Real
    stars::Real
    reviewcount::Int
    categories::Array{AbstractString}
end


struct User
    id::AbstractString
    name::AbstractString
    reviewcount::Int
    totcompliment::Int
    avgstars::Real
    friends::Vector{AbstractString}
end

struct Review
    id::AbstractString
    user::AbstractString
    business::AbstractString
    stars::Int
    date::AbstractString
    useful::Int
    funny::Int
    cool::Int
end
