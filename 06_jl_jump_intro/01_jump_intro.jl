using GLPKMathProgInterface
using JuMP

#Julia 1.0 Programming Cookbok - B. Kaminski & P. Szufel (2018)
m = Model(solver = GLPKSolverLP());
@variable(m, x₁ >= 0)
@variable(m, x₂ >= 0)

@objective(m, Min, 50x₁ + 70x₂)

@constraint(m, 200x₁ + 2000x₂ >= 9000);
@constraint(m, 100x₁ +   30x₂ >=  300);
@constraint(m, 9x₁   +   11x₂ >=   60);

println(m)

status = solve(m)

println("Cost: $(getobjectivevalue(m))\nx₁=$(getvalue(x₁))\nx₂=$(getvalue(x₂))")


m = Model(solver = GLPKSolverMIP());
@variable(m, x₁ >= 0)
@variable(m, x₂ >= 0, Int)
@objective(m, Min, 50x₁ + 70x₂)
@constraint(m, 200x₁ + 2000x₂ >= 9000)
@constraint(m, 100x₁ +   30x₂ >=  300)
@constraint(m, 9x₁   +   11x₂ >=   60)

status = solve(m)
println("Cost: $(getobjectivevalue(m))\nx₁=$(getvalue(x₁))\nx₂=$(getvalue(x₂))")
