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
br = 1.1

model = ConcreteModel(name="Harvesting linearized")

model.f = Var(within=NonNegativeReals)
model.d = Var(within=NonNegativeReals)
model.b = Var(within=NonNegativeReals)
model.hf = Var(within=NonNegativeReals)
model.hd = Var(within=NonNegativeReals)
model.hb = Var(within=NonNegativeReals)
model.c = Var(within=NonNegativeReals)

def obj_rule(m):
    return 10*m.hb + m.hd + m.hf

model.obj = Objective(rule=obj_rule, sense=maximize)

def f_bal_rule(m):
    return m.f == p1*br *(p2/10.0*m.f + p3*m.d) - m.hf

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
    return m.c == ps

model.supply = Constraint(rule=supply_rule)

def minbuck_rule(m):
    return m.b >= 1.0/5.0*(0.4*m.f + m.d)

model.minbuck = Constraint(rule=minbuck_rule)

solver = SolverFactory("glpk")
results = solver.solve(model)
print(results)
model.pprint()
