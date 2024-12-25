from collections import defaultdict
from pathlib import Path


def solve(data: str, part: int):
    stones = map(int, data.split())
    pile = defaultdict(int)
    for stone in stones:
        pile[stone] += 1

    blinks = 25 if part == 1 else 75

    def blink(stone: int):
        if stone == 0:
            return [1]
        digits = str(stone)
        if len(digits) % 2 == 0:
            half = len(digits) // 2
            return [int(digits[:half]), int(digits[half:])]
        return [stone * 2024]

    for _ in range(blinks):
        oldpile = pile
        pile = defaultdict(int)
        for stone, count in oldpile.items():
            new_stones = blink(stone)
            for x in new_stones:
                pile[x] += count

    return sum(pile.values())


def main():
    def do(fname, part):
        with open(Path(fname), "r") as f:
            data = f.read().strip()
            print(Path(fname), part, solve(data, part))

    do("./sample", 1)
    do("./in", 1)
    do("./sample", 2)
    do("./in", 2)


if __name__ == "__main__":
    main()
