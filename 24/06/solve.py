import itertools as it
from pathlib import Path
from tqdm import tqdm


def solve(fname, part):
    data = open(fname, "r").read()
    grid = [list(line) for line in data.splitlines()]
    height = len(grid)
    width = len(grid[0])
    guard_pos = next(((x, y) for x, y in it.product(range(width), range(height)) if grid[y][x] == "^"))
    guard_dirs = it.cycle([(0, -1), (1, 0), (0, 1), (-1, 0)])
    current_dir = next(guard_dirs)
    x, y = guard_pos
    grid[x][y] = "."
    if part == 1:
        visited = set()
        while True:
            # print grid
            # for i in range(height):
            #     for j in range(width):
            #         if (x, y) == (j, i):
            #             print("X", end="")
            #         elif (j, i) in visited:
            #             print("*", end="")
            #         else:
            #             print(grid[i][j], end="")
            #     print()
            # print()
            # end
            if not (x in range(width) and y in range(height)):
                break
            if grid[y][x] == "#":
                x -= current_dir[0]
                y -= current_dir[1]
                current_dir = next(guard_dirs)
            else:
                visited.add((x, y))
            x += current_dir[0]
            y += current_dir[1]

        return len(visited)
    elif part == 2:
        loop_rocks = []
        for rockx, rocky in tqdm(it.product(range(width), range(height)), total=width * height):
            guard_dirs = it.cycle([(0, -1), (1, 0), (0, 1), (-1, 0)])
            current_dir = next(guard_dirs)
            x, y = guard_pos
            turns = set()
            prev = grid[rocky][rockx]
            grid[rocky][rockx] = "#"
            while True:
                if not (x in range(width) and y in range(height)):
                    break
                if grid[y][x] == "#":
                    x -= current_dir[0]
                    y -= current_dir[1]
                    current_dir = next(guard_dirs)
                    # loop found
                    if (x, y, current_dir) in turns:
                        loop_rocks.append((rockx, rocky))
                        break
                    else:
                        turns.add((x, y, current_dir))
                x += current_dir[0]
                y += current_dir[1]

            grid[rocky][rockx] = prev

        return len(loop_rocks)


print(solve(Path("./sample"), 1))
print(solve(Path("./in"), 1))
print(solve(Path("./sample"), 2))
print(solve(Path("./in"), 2))
