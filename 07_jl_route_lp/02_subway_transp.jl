
using CSV
using DataFrames
using GLPKMathProgInterface
using JuMP

distance_data = CSV.read("distance_data.csv",header=[:i,:j,:dist,:route],missing=:none)

#we assume that the sandwich ingriedients are transported 
# from the first 18 restaurants to the 100 others
S = 18
D = 100

# sample values supply and demand
supply = fill(100,S)
demand = fill(15,D)


const distance_mx = zeros(Float64,(S,D))
for r in 1:nrow(distance_data)
   i = distance_data.i[r]
   j = distance_data.j[r]
   if i <= S && j > S
      distance_mx[i,j-S] = distance_data.dist[r]
   end
end


m = Model(solver=GLPKSolverLP())
@variable(m, x[i=1:S,j=1:D])

@objective(m, Min, sum( x[i,j]*distance_mx[i,j] for i=1:S,j=1:D))

@constraint(m,x .>= 0)
for j=1:D
   @constraint(m, sum( x[i,j] for i=1:S) >= demand[j]   )
end

for i=1:S
   @constraint(m, sum( x[i,j] for j=1:D) <= supply[i]   )
end

status = solve(m)

res = getvalue(x)

println(res)
