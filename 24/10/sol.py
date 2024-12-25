from pathlib import Path
from collections import defaultdict

nums = "0123456789"
edges = dict(zip(nums, nums[1:])) | {"9": "", ".": "x"}


def solve(data: str, part: int):
    grid = data.splitlines()
    graph = defaultdict(list)
    width = len(grid[0])
    height = len(grid)
    for i, row in enumerate(grid):
        for j, elem in enumerate(row):
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                di, dj = i + dy, j + dx
                if di in range(height) and dj in range(width):
                    if edges[elem] == grid[di][dj]:
                        graph[(i, j)].append((di, dj))

    trails = defaultdict(set if part == 1 else list)
    insert = (lambda xs, e: xs.append(e)) if part != 1 else (lambda xs, e: xs.add(e))

    def dfs(start, current, visited):
        if part == 1:
            visited.add(current)
        for neigh in graph[current]:
            if neigh not in visited:
                if grid[neigh[0]][neigh[1]] == "9":
                    insert(trails[start], neigh)
                else:
                    dfs(start, neigh, visited)

    for i, row in enumerate(grid):
        for j, elem in enumerate(row):
            if elem == "0":
                dfs((i, j), (i, j), set())

    return sum(len(finishes) for _, finishes in trails.items())


def main():
    def do(fname, part):
        with open(Path(fname), "r") as f:
            data = f.read().strip()
            print(fname, part, solve(data, part))

    # do("./sample1", 1)
    # do("./sample2", 1)
    do("./sample", 1)
    do("./in", 1)
    do("./sample", 2)
    do("./in", 2)


if __name__ == "__main__":
    main()
