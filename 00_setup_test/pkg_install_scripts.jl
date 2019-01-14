using Pkg

Pkg.add("JuMP")
Pkg.add("DataFrames")
Pkg.add("GLPK")
Pkg.add("Ipopt")
Pkg.add("PyCall")
Pkg.add("Conda")
Pkg.add("PyPlot")
Pkg.add("Plots")
Pkg.add("CSV")
Pkg.add("MultiJuMP")
Pkg.add("GLPKMathProgInterface")
Pkg.add("LightGraphs")
Pkg.add(PackageSpec(url="https://github.com/pszufe/OpenStreetMapX.jl"))

Pkg.add("Gurobi") # this package is optional
Pkg.add("IJulia") # this package is optional
