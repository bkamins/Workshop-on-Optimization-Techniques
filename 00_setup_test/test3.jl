using GLPKMathProgInterface
using JuMP

m = Model(solver = GLPKSolverMIP());
@variable(m, x, Int)
@variable(m, y, Int)
@objective(m, Min, x + y)
@constraint(m, 2x + y >= 3);
@constraint(m, x +  2y >=  3);

status = solve(m)
println("x=$(getvalue(x)), y=$(getvalue(y))")
# should print: x=1.0, y=1.0
