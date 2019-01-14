from pyomo.environ import *

model = ConcreteModel(name="Infeasible")
model.x = Var(within=NonNegativeReals)
model.obj = Objective(expr= model.x, sense=maximize)
model.constr = Constraint(expr= model.x <= -1)
solver = SolverFactory("glpk")
results = solver.solve(model)
print(results)
model.pprint()

model = ConcreteModel(name="Unbounded")
model.x = Var(within=NonNegativeReals)
model.obj = Objective(expr= model.x, sense=maximize)
model.constr = Constraint(expr= model.x >= -1)
solver = SolverFactory("glpk")
results = solver.solve(model)
print(results)
model.pprint()


from pyomo.opt import TerminationCondition
results.solver.termination_condition
TerminationCondition.optimal
TerminationCondition.unbounded
TerminationCondition.infeasible
