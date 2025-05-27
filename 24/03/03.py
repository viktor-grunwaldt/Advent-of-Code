import re
from operator import itemgetter
matches = re.findall(r"((mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\)))", input())
ops = list(map(itemgetter(0), matches))
def solve(pt):
    cond = 1
    res = 0
    def mul (x,y): 
        nonlocal res
        res += x*y*cond

    for op in ops:
        if op == "do()":
            cond = 1
        if op == "don't()":
            cond = 0 if pt == "part 2" else 1
        if op[:3] == "mul":
            eval(op)

    print(pt, res)

solve("part 1")
solve("part 2")

