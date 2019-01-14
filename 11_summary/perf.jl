using JuMP
using GLPKMathProgInterface

function genproblem()
    m = Model(solver=GLPKSolverMIP())
    @variable(m, x[1:4_000_000])
    @variable(m, y[1:2000], Bin)
    @objective(m, Max, sum(x)+sum(y))
    for i in 1:4_000_000
        @constraint(m, x[i] <= i)
    end
    for i in 1:2000, j in 1:2000
        @constraint(m, y[i] + y[j] <= 1)
    end
    m
end

@time genproblem();
