package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestDay3(t *testing.T) {
  output := utils.ExecuteDay(main)
  utils.Assert(t, "part1 = 7", output[0])
  utils.Assert(t, "part2 = 336", output[1])
}
