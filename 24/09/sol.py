#!/usr/bin/env python
from itertools import accumulate, batched, islice
from pathlib import Path
import heapq


def show_disk(disk):
    print("".join(str(x) if x is not None else "." for x in disk))


def solve(data, part):
    sectors = [int(c) for c in data]
    # strip last, empty space
    if sectors.__len__() % 2 == 1:
        sectors.append(0)
    disk = []
    for idx, (file, space) in enumerate(batched(sectors, 2)):
        disk.extend([idx] * file + [None] * space)
    fwd_ptr = 0
    back_ptr = len(disk) - 1
    checksum = 0
    if part == 1:
        while fwd_ptr < back_ptr:
            if disk[fwd_ptr] is not None:
                checksum += fwd_ptr * disk[fwd_ptr]
                fwd_ptr += 1
                continue
            if disk[back_ptr] is None:
                back_ptr -= 1
                continue

            disk[fwd_ptr] = disk[back_ptr]
            disk[back_ptr] = None

    elif part == 2:
        # show_disk(disk)

        def my_heappush(hole_size, elem):
            if hole_size != 0:
                heapq.heappush(holes[hole_size], elem)

        sector_positions = [0] + list(accumulate(sectors))
        holes = [[] for _ in range(10)]
        for idx, c in islice(enumerate(sectors), 1, None, 2):
            my_heappush(c, idx)

        segments_backwards = reversed(list(islice(enumerate(sectors), 0, None, 2)))
        for idx, c in segments_backwards:
            leftmost_possible = sector_positions[idx]

            pos = None
            for j, hole in enumerate(holes[c:]):
                if hole and hole[0] < leftmost_possible:
                    leftmost_possible = hole[0]
                    pos = j + c
            if pos is None:
                continue

            hole_size = pos
            heapq.heappop(holes[hole_size])
            if sector_positions[idx] < sector_positions[leftmost_possible]:
                # I thought that sector_positions[idx] would be the sectors
                # index and thus it's impossible to move the element to the right
                # apparently not
                # print("uh oh")
                continue

            # remove sector
            for j in range(sector_positions[idx], sector_positions[idx] + c):
                assert disk[j] == idx // 2
                disk[j] = None

            # move sector to leftmost hole
            for j in range(
                sector_positions[leftmost_possible],
                sector_positions[leftmost_possible] + c,
            ):
                assert disk[j] is None
                disk[j] = idx // 2

            # insert leftover hole
            hole_size_remaining = hole_size - c
            my_heappush(hole_size_remaining, leftmost_possible)
            sector_positions[leftmost_possible] += c
            # show_disk(disk)

        # calc checksum
        # show_disk(disk)
        checksum = sum(i * (0 if f is None else f) for i, f in enumerate(disk))
    return checksum


with open("sample", "r") as f:
    data_sample = f.read().strip()

with open("in", "r") as f:
    data = f.read().strip()

print("test", solve(data_sample, 1))
print("part 1", solve(data, 1))
print("test", solve(data_sample, 2))
print("part 2", solve(data, 2))
