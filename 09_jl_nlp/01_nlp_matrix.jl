using Ipopt
using JuMP
using LinearAlgebra

# here we generate a sample problem structure
x = rand(Float64,(1000,2))*Diagonal([6,10]) .- [4 3]
e = rand(1000).*2 #errors

a, b, c = 1, 10, 7 # actual values that we want to estimate
A = [a b/2;b/2 c]

# y = a * x₁² + b*x₁x₂ + c x₂²
y = (x * A ) .* x * [1;1] .+ e # y - explained variable

m = Model(solver = Ipopt.IpoptSolver());
@variable(m, aa[1:2,1:2])

function errs(aa)
   sum((y .- (x * aa ) .* x * [1;1]) .^ 2)
end

@objective(m, Min, errs(aa))

status = solve(m)

println("Cost: $(getobjectivevalue(m))")
res = getvalue(aa)
println("aa=$res")
println("a, b, c = $(res[1,1]), $(res[1,2]+res[2,1]), $(res[2,2])")
