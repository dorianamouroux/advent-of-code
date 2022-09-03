package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestDay2(t *testing.T) {
  output := utils.ExecuteDay(main)
  utils.Assert(t, "part1 = 2", output[0])
  utils.Assert(t, "part2 = 1", output[1])
}
