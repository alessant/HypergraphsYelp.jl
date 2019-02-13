using Test

const testdir = dirname(@__FILE__)


tests = [
    #"",
]


@testset "HypergraphsYelp" begin
    for t in tests
        tp = joinpath(testdir, "test-$(t).jl")
        include(tp)
    end
end
