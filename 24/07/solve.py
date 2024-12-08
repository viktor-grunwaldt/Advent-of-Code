import itertools as it
from pathlib import Path


def try_ops(nums, ans, ops):
    for ops in it.product(ops, repeat=len(nums) - 1):
        acc = nums[0]
        for num, op in zip(nums[1:], ops):
            if op == "add":
                acc += num
            elif op == "mul":
                acc *= num
            elif op == "||":
                acc = int(f"{acc}{num}")
            if acc > ans:
                break

        if acc == ans:
            return True
    return False


def solve(fname, part):
    data = open(fname, "r").read()
    correct_test_values = []
    for line in data.splitlines():
        ans, nums_str = line.split(": ")
        ans = int(ans)
        nums = list(map(int, nums_str.split()))
        count = len(nums)
        if part == 1:
            if try_ops(nums, ans, ["add", "mul"]):
                correct_test_values.append(ans)
        elif part == 2:
            if try_ops(nums, ans, ["add", "mul", "||"]):
                correct_test_values.append(ans)

    return sum(correct_test_values)


print(solve(Path("./sample"), 1))
print(solve(Path("./in"), 1))
print(solve(Path("./sample"), 2))
print(solve(Path("./in"), 2))
