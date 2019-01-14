using Ipopt
using JuMP

m = Model(solver = IpoptSolver());
@variable(m, x, start=10)
@variable(m, y, start=10)
@NLexpression(m, rosenbrock, (1 - x)^2 + 100(y - x^2)^2)
@NLobjective(m, Min, rosenbrock)

status = solve(m)
println("x=$(getvalue(x)), y=$(getvalue(y))")
# should print: x=1.0000000150180794, y=1.0000000145234784
