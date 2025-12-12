# Advent of Code 2025

## Changes

there are now only 12 days of AoC.

## Running

Out of convenience, I solve challenges in OCaml's REPL - utop.

Most days have a `session.ml` file, which is a cleaned up dump of what I've wrote to solve the puzzle.

to run it:
- save input to `input.txt` in the same directory as `session.ml`
- enter `utop`
- run command `#require "str";;` to load the `Str` module (for some days I used regex, which isn't available by default)
- load session `#use "session.ml";;`
- solve part 1 `p1 data;;`
- solve part 2 `p2 data;;`
