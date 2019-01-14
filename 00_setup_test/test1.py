from pyomo.environ import *

model = ConcreteModel(name="Test1")
model.x = Var(within=Integers)
model.y = Var(within=Integers)
model.o = Objective(expr= model.x+model.y)
model.c1 = Constraint(expr= 2*model.x+model.y >= 3)
model.c2 = Constraint(expr= model.x+2*model.y >= 3)

solver = SolverFactory("glpk")
results = solver.solve(model)
print(value(model.x), value(model.y))
# should print: 1.0 1.0
