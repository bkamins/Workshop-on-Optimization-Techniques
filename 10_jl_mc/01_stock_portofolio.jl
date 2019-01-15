using CSV
using DataFrames
using Statistics
using JuMP
using MultiJuMP
using Ipopt
using Plots 



prices = CSV.read("10_stocks_3yr.csv", allowmissing=:none)
prices.rateOfRet = (prices.close-prices.open) ./ prices.open
dats = unstack(prices, :date, :Name, :rateOfRet)
const avg_rets = colwise(mean, dats[2:end])
const cov_mx = cov(Matrix(dats[2:end]))

m = MultiModel(solver = IpoptSolver())
@variable(m, 0 <= x[i=1:10] <= 1)
@constraint(m,sum(x) == 1)

@variable(m, risk)
@constraint(m, risk == x'*cov_mx*x)

@variable(m, rets)
@constraint(m, rets == avg_rets' * x)

@NLexpression(m, f_risk, risk)
@NLexpression(m, f_rets, rets)

iv1 =  fill(0.1, 10) # Initial guess
obj1 = SingleObjective(f_risk, sense = :Min,
                       iv = Dict{Symbol,Any}(:x => iv1))
obj2 = SingleObjective(f_rets, sense = :Max)

md = getMultiData(m)
md.objectives = [obj1, obj2]
md.pointsperdim = 20

open("solver_trace.txt", "w") do io
    redirect_stdout(io) do
        solve(m, method = :NBI) # method = :WS or method = :EPS
    end
end

Plots.pyplot()
pltnbi = plot(md)
