from pathlib import Path
from collections import defaultdict
import itertools as it


def solve(data: str, part: int):
    grid = data.splitlines()
    height = len(grid)
    width = len(grid[0])
    graph = defaultdict(list)
    for i, row in enumerate(grid):
        for j, elem in enumerate(row):
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                y, x = i + dx, j + dy
                if x in range(width) and y in range(height):
                    if elem == grid[y][x]:
                        graph[(i, j)].append((y, x))

    def dfs(current, visited):
        visited.add(current)
        edges = 0
        for neigh in graph[current]:
            edges += 1
            if neigh not in visited:
                edges += dfs(neigh, visited)

        return edges

    visited = set()
    ans = 0
    for p in it.product(range(height), range(width)):
        if p not in visited:
            cluster = set()
            edges = dfs(p, cluster)
            area = len(cluster)
            perim = area * 4 - edges
            # print("region", p, perim, area, edges)
            ans += perim * area
            visited = visited | cluster

    return ans


def main():
    def do(fname, part):
        with open(Path(fname), "r") as f:
            data = f.read().strip()
            print(Path(fname), part, solve(data, part))

    do("./sample1", 1)
    do("./sample2", 1)
    do("./in", 1)
    # do("./sample", 2)
    # do("./in", 2)


if __name__ == "__main__":
    main()
