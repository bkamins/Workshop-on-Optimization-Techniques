using JuMP
using GLPKMathProgInterface

function sudokusolver(board)
    m = Model(solver=GLPKSolverMIP())
    @variable(m, x[1:9, 1:9, 1:9], Bin)
    for i in 1:9, j in 1:9
        @constraint(m, sum(x[i, j, :]) == 1)
        @constraint(m, sum(x[i, :, j]) == 1)
        @constraint(m, sum(x[:, i, j]) == 1)
        for (i, j, k) in board
            @constraint(m, x[i, j, k] == 1)
        end
    end
    for i in 0:2, j in 0:2, k in 1:9
        @constraint(m, sum(x[3i .+ (1:3), 3j .+ (1:3), k]) == 1)
    end

    solution_count = 0
    sol = zeros(Int, 9, 9)
    while true
        res = solve(m)
        if res == :Optimal
            solution_count += 1
            print("Solution #$solution_count")
            xv = round.(Int, getvalue(x))
            for idx in findall(==(1), xv)
                sol[idx[1], idx[2]] = idx[3]
            end
            display(sol)
            @constraint(m, sum(xv .* x) <= 80)
        else
            print("All board solutions have been found")
            return
        end
    end
end

board = [(1,1,5),(1,2,3),(1,5,7),(2,1,6),(2,4,1),(2,5,9),(2,6,5),
         (3,2,9),(3,3,8),(3,8,6),(4,1,8),(4,5,6),(4,9,3),(5,1,4),
         (5,4,8),(5,6,3),(5,9,1),(6,1,7),(6,5,2),(6,9,6),(7,2,6),
         (7,7,2),(7,8,8),(8,4,4),(8,5,1),(8,6,9)]

sudokusolver(board)
