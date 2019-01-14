from pyomo.environ import *

demand = [30.0, 15.0, 15.0, 25.0, 33.0, 40.0,
          45.0, 45.0, 26.0, 14.0, 25.0, 30.0]

cost_normal = 32 *1000
cost_overtime = 40 * 1000
cost_store = 5 * 1000
capacity = 30
n = len(demand)

model = ConcreteModel(name="Bicycle")
model.time = RangeSet(1,n)
model.store_time = RangeSet(0,n)
model.prod_normal = Var(model.time, bounds=(0,capacity))
model.prod_overtime = Var(model.time, bounds=(0,capacity / 2))
model.store = Var(model.store_time, within=NonNegativeReals)

model.obj = Objective(expr=sum(cost_normal*model.prod_normal[i] +
                               cost_overtime*model.prod_overtime[i] +
                               cost_store*model.store[i] for i in model.time),
                      sense=minimize)

def time_constraint(model, t):
    inflow = model.prod_normal[t] + model.prod_overtime[t] + model.store[t-1]
    outflow = demand[t-1] + model.store[t]
    return inflow == outflow

model.constr = Constraint(model.time, rule=time_constraint)
model.store[0].fix(2.0)

solver = SolverFactory("glpk")
results = solver.solve(model)
print(results)
model.pprint()

print("demand\tnormal\tover\tstore")
for t in range(1, 13):
    print("{:4}\t{:4}\t{:4}\t{:4}".format(demand[t-1],
          value(model.prod_normal[t]),
          value(model.prod_overtime[t]), value(model.store[t])))
