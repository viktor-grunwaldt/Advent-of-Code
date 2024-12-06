from pprint import pprint
from pathlib import Path
import itertools as it

WORD = "XMAS"


def get_or_none(data, i, j):
    try:
        return data[i][j]
    except IndexError:
        return None


def part1(fname):
    data = list(map(str.strip, open(fname, "r").readlines()))
    angled_left = [
        "".join(filter(None, (get_or_none(data, i, j - i) for i in range(0, j + 1))))
        for j in range(2 * len(data))
    ]
    rev_data = data[::-1]
    angled_right = [
        "".join(
            filter(None, (get_or_none(rev_data, i, j - i) for i in range(0, j + 1)))
        )
        for j in range(2 * len(data))
    ]
    vertical = list(map(lambda s: "".join(s), zip(*data)))
    roots = [data, angled_left, angled_right, vertical]
    labels = ["normal", "down_left", "down_right", "vertical"]
    occurences = list(
        sum(line.count(WORD) + line.count(WORD[::-1]) for line in lines)
        for lines in roots
    )
    return sum(occurences)


PATTERN = "MMSS"


def part2(fname):
    data = list(map(str.strip, open(fname, "r").readlines()))
    height = len(data)
    width = len(data[0])
    middles = (
        (i, j)
        for i, j in it.product(range(1, height - 1), range(1, width - 1))
        if data[i][j] == "A"
    )
    patterns = ["MMSS", "SSMM", "MSMS", "SMSM"]
    ret = 0
    for i, j in middles:
        # fmt: off
        corners = "".join((
                data[i - 1][j - 1],
                data[i - 1][j + 1],
                data[i + 1][j - 1],
                data[i + 1][j + 1],
        ))
        # fmt: on
        ret += 1 if corners in patterns else 0

    return ret


print(part1(Path("./sample")))
print(part1(Path("./in")))
print(part2(Path("./sample")))
print(part2(Path("./in")))
