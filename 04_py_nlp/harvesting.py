from pyomo.environ import *

p1 = 0.88
p2 = 0.82
p3 = 0.92
p4 = 0.84
p5 = 0.73
p6 = 0.87
p7 = 2700.0
p8 = 2300.0
p9 = 540.0
ps = 700000.0

model = ConcreteModel(name="Harvesting")

model.f = Var(initialize = 20.0, within=NonNegativeReals)
model.d = Var(initialize = 20.0, within=NonNegativeReals)
model.b = Var(initialize = 20.0, within=NonNegativeReals)
model.hf = Var(initialize = 20.0, within=NonNegativeReals)
model.hd = Var(initialize = 20.0, within=NonNegativeReals)
model.hb = Var(initialize = 20.0, within=NonNegativeReals)
model.br = Var(initialize=1.5, within=NonNegativeReals)
model.c = Var(initialize=500000.0, within=NonNegativeReals)

def obj_rule(m):
    return 10*m.hb + m.hd + m.hf

model.obj = Objective(rule=obj_rule, sense=maximize)

def f_bal_rule(m):
    return m.f == p1*m.br *(p2/10.0*m.f + p3*m.d) - m.hf

model.f_bal = Constraint(rule=f_bal_rule)

def d_bal_rule(m):
    return m.d == p4*m.d + p5/2.0*m.f - m.hd

model.d_bal = Constraint(rule=d_bal_rule)

def b_bal_rule(m):
    return m.b == p6*m.b + p5/2.0*m.f - m.hb

model.b_bal = Constraint(rule=b_bal_rule)

def food_cons_rule(m):
    return m.c == p7*m.b + p8*m.d + p9*m.f

model.food_cons = Constraint(rule=food_cons_rule)

def supply_rule(m):
    return m.c <= ps

model.supply = Constraint(rule=supply_rule)

def birth_rule(m):
    return m.br == 1.1 + 0.8*(ps - m.c)/ps

model.birth = Constraint(rule=birth_rule)

def minbuck_rule(m):
    return m.b >= 1.0/5.0*(0.4*m.f + m.d)

model.minbuck = Constraint(rule=minbuck_rule)

solver = SolverFactory("ipopt")
results = solver.solve(model)
print(results)
model.pprint()
