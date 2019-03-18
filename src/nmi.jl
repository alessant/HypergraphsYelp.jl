
function nmi(p1::Array{Int64}, p2::Array{Int64})

    hp1 = Dict{Int64,Set{Int64}}()
    hp2 = Dict{Int64,Set{Int64}}()

    n = length(p1)

    for i in 1:length(p1)
        v = p1[i]
        if !haskey(hp1, v)
            push!(hp1, v=>Set{Int64}())
        end
        push!(hp1[v],i)
    end

    for i in 1:length(p2)
        v = p2[i]
        if !haskey(hp2, v)
            push!(hp2, v=>Set{Int64}())
        end
        push!(hp2[v],i)
    end
    np1 = length(values(hp2))
    np2 = length(values(hp2))
    nhl = Dict{Pair{Int64,Int64},Int64}()
    #Array{Int64,2}(undef, np1, np2)
"""
    for i in keys(hp1)
        for j in keys(hp2)
            push!(nhl, (i=>j)=>length(intersect(hp2[j],hp1[i])))
        end
    end
"""
    IAB = 0.0
    for i in keys(hp1)
        for j in keys(hp2)
            nhl = length(intersect(hp2[j],hp1[i]))
            if nhl != 0
                IAB+= nhl * log2( n * nhl / (length(hp1[i])*length(hp2[j])))
            end
        end
    end

    HA = 0.0
    for i in keys(hp1)
        HA += length(hp1[i]) * log2(length(hp1[i])/n)
    end

    HB = 0.0
    for j in keys(hp2)
        HB += length(hp2[j]) * log2(length(hp2[j])/n)
    end

    return - (2 * IAB) / (HA + HB)

end
