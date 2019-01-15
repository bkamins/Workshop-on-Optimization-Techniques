using Ipopt
using JuMP
using LinearAlgebra

const obs_cases = vcat(1,2,4,8,15,27,44,58,55,32,12,3,1,zeros(13))
const SI_max = length(obs_cases)
const N = 300

m = Model(solver = Ipopt.IpoptSolver());
@variable(m, 0.5 <= α <= 1.5)
@variable(m, 0.05 <= β <= 70)
@variable(m, 0 <= I_[1:SI_max] <= N)

@variable(m, 0 <= S[1:SI_max]  <= N)
@variable(m, ε[1:SI_max])
@constraint(m, ε .== I_ .- obs_cases  )
@constraint(m, I_[1] == 1)
for i=2:SI_max
   @NLconstraint(m, I_[i] == β*(I_[i-1]^α)*S[i-1]/N)
end

@constraint(m, S[1] == N)
for i=2:SI_max
   @constraint(m, S[i] == S[i-1]-I_[i])
end

@NLobjective(m, Min, sum(ε[i]^2 for i in 1:SI_max))

status = solve(m)

println("Cost: $(getobjectivevalue(m))")
println("α=$(getvalue(α))\nβ=$(getvalue(β))")
