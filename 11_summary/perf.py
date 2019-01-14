from pyomo.environ import *
from timeit import default_timer as timer

def genproblem():
    m = ConcreteModel()
    m.XRANGE = RangeSet(1,4000000)
    m.YRANGE = RangeSet(1,2000)
    m.x = Var(m.XRANGE)
    m.y = Var(m.YRANGE, within=Binary)
    m.obj = Objective(expr=sum(m.x[i] for i in m.XRANGE) +
                          sum(m.y[i] for i in m.YRANGE))
    def xconstraint(m, i):
        return m.x[i] <= i
    m.con1 = Constraint(m.XRANGE, rule=xconstraint)
    def yconstraint(m, i, j):
        return m.y[i] + m.y[j] <= 1
    m.con2 = Constraint(m.YRANGE, m.YRANGE, rule=yconstraint)
    return m

start = timer()
genproblem()
end = timer()
print(end - start)
