# codes from the Julia introduction

# Start Atom Juno and press Ctrl+Enter line-by-line 

t = ()


typeof(t)

t2 = (13,"hello")
typeof(t2)
x = (1, 2, 3)

x[1:2]  #1-based indexing
x[1]=9 #not mutable

Array{Float64}(undef, 4, 5, 2)


ones(Int64, 4, 3)

using LinearAlgebra
Matrix{Float64}(I,3,3)


x = range(1, stop=2, length=5)
typeof(x)
collect(x)

typeof(1:12)
collect(1:12)

(1:12) .+ 7


c = reshape(1:12, 3, 4)
d = collect(c)
d'

c[:,1:2]




mutable struct Point
	x::Int64
	y::Float64
	meta
end
p = Point(4.0, 5.6, "blah")
p.x
p.meta
fieldnames(typeof(p))
p.meta = "blah blah"
dump(p)

python_styl_dict = Dict{Any}{Any}()

x = Dict{Float64, Int64}()

x2 = Dict(1 => "helo", 2=>"World", 3.0=>"Bye")
x3 = Dict{Union{Int64,Float64},String}(1 => "helo", 2=>"World", 3.0=>"Bye")

keys(x2)
collect(keys(x2))
values(x2)
collect(values(x2))

"Hello" * " world"
"Hello " ^ 4

x = 7
println("The result is $x !")
println("The result x+2 is $(x+2) !")

#searching strings

r = r"A|B"  #regular expression
r2 = "A"
occursin(r,"SDSDA")
occursin(r2,"SDSDA")

f(x, y = 10) = x + y
f(100)
f(100,200)
f(10,5)

f2(;x1=10,x2=30) = x1+x2
f2(x2=0,x1=7)

@code_native f(1,2)

@code_native f(1.0,2)

f(x, y) = x + y
f(x::Int,y::Int) = x-y
f(1,10)
f(1,10.0)


g2(x::Int64,y::Int64) = x*y
a1 = [1,2,3,4]
a2 = [1,2,3,5]
g2(a1,a2)
g2.(a1,a2)


function our_pi(n, T)
    s = one(T)
    f = one(T)
    for i::T in 1:n
        f *= i/(2i+1)
        s += f
    end
    2s
end

1//4 + 1//2
println(our_pi(20,Rational))



for T in [Float16, Float64, BigFloat]
	display([our_pi(2^n, T) for n in 1:10] .- big(π))
end

typeof(π)

display([our_pi(n, Rational) for n in 1:10])



file = open("some_name.txt","w")
println(file,"aaaa aaa")
close(file)

open("some_name.txt","w") do f2
	println(f2,"aaaa aaa")
end

f3 = open("some_name.txt")
readline(f3)
close(f3)


function ssum(x)
    r, c = size(x)
    y = zeros(c)
    for i in 1:c
        for j in 1:r
            y[i] += x[j, i]
        end
    end
    y
end

function tsum(x)
    r, c = size(x)
    y = zeros(c)
    Threads.@threads for i in 1:c
        for j in 1:r
            y[i] += x[j, i]
        end
    end
    y
end

x = rand(Int64,(1000,1000))

Threads.nthreads()
using BenchmarkTools
@btime ssum($x)

@btime tsum($x)
