from pyomo.environ import *

model = ConcreteModel(name="Test2")
model.x = Var(initialize=10)
model.y = Var(initialize=10)

def rosenbrock(model):
    return (1.0-model.x)**2 + 100.0*(model.y - model.x**2)**2

model.obj = Objective(rule=rosenbrock, sense=minimize)

solver = SolverFactory("ipopt")
results = solver.solve(model)
print(value(model.x), value(model.y))
# should print: 1.0000000152055715 1.0000000147239585
