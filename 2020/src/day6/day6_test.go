package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestDay6(t *testing.T) {
  output := utils.ExecuteDay(main)
  utils.Assert(t, "part1 = 11", output[0])
  utils.Assert(t, "part2 = 6", output[1])
}
