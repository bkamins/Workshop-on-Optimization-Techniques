from pyomo.environ import *

model = ConcreteModel(name="Chess set 2")
model.xs = Var(within=NonNegativeIntegers)
model.xl = Var(within=NonNegativeIntegers)
model.obj = Objective(expr= 5*model.xs + 20*model.xl, sense=maximize)
model.latehours = Constraint(expr= 3*model.xs + 2*model.xl <= 160)
model.boxwood = Constraint(expr= 1*model.xs+3*model.xl <= 200)

solver = SolverFactory("glpk")
results = solver.solve(model)
print(results)
print(value(model.xs), value(model.xl))
model.obj.pprint()
model.latehours.pprint()
model.boxwood.pprint()
