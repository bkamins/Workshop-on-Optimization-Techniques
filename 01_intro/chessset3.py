from pyomo.environ import *

def objective(m):
    return 5*m.xs + 20*m.xl

def latehours(m):
    return 3*m.xs + 2*m.xl <= 160

def boxwood(m):
    return 1*m.xs + 3*m.xl <= 200

constraints = [latehours, boxwood]

def constraint(m, idx):
    return constraints[idx](m)

def chess_set(onlyint):
    typ = NonNegativeIntegers if onlyint else NonNegativeReals
    model = ConcreteModel(name="Chess set")
    model.xs = Var(within=typ)
    model.xl = Var(within=typ)
    model.obj = Objective(rule=objective, sense=maximize)
    model.constr = Constraint([0,1], rule=constraint)
    solver = SolverFactory("glpk")
    solver.solve(model)
    return model

res = chess_set(False)
res.pprint()
res = chess_set(True)
res.pprint()
