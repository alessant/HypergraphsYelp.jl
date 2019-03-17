using Pkg
Pkg.add("Documenter")
using Documenter


try
    using HypergraphsYelp
catch
    if !("../src/" in LOAD_PATH)
	   push!(LOAD_PATH,"../src/")
	   @info "Added \"../src/\"to the path: $LOAD_PATH "
	   using HypergraphsYelp
    end
end

makedocs(
    sitename = "HypergraphsYelp",
    format = Documenter.HTML(),
    modules = [HypergraphsYelp],
	pages = ["index.md"],
	doctest = true
)

#deploydocs(
#    repo ="github.com/aleant93/HypergraphsYelp.jl.git",
#	target="build"
#)
