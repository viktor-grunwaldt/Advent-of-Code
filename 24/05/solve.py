from collections import defaultdict
from pathlib import Path


def solve(fname):
    data = open(fname, "r").read()
    page_ordering_rules, update_sequences = data.split("\n\n")
    graph = defaultdict(list)
    antigraph = defaultdict(list)
    for line in page_ordering_rules.splitlines():
        before, after = map(int, line.split("|"))
        graph[before].append(after)
        antigraph[after].append(before)

    res = []
    res2 = []
    is_correctly_ordered = True
    for update_seq in update_sequences.splitlines():
        is_correctly_ordered = True
        pages = list(map(int, update_seq.split(",")))
        for i, page in enumerate(pages):
            if not all(page_after in graph[page] for page_after in pages[i + 1 :]):
                is_correctly_ordered = False
                break

        if is_correctly_ordered:
            res.append(pages[len(pages) // 2])
        else:
            topologically_sorted = []
            queue = []
            pages_set = set(pages)
            d = {page: len(set(graph[page]) & pages_set) for page in pages}
            for page in pages:
                if d[page] == 0:
                    queue.append(page)

            while queue:
                current = queue.pop(0)
                topologically_sorted.append(current)
                for page_before in antigraph[current]:
                    if page_before in d:
                        d[page_before] -= 1
                        if d[page_before] == 0:
                            queue.append(page_before)

            res2.append(topologically_sorted[len(topologically_sorted) // 2])

    print(res, sum(res))
    print(res2, sum(res2))


if __name__ == "__main__":
    solve(Path("./sample"))
    solve(Path("./in"))
