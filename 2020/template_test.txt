package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestDay1(t *testing.T) {
  output := utils.ExecuteDay(main)
  utils.Assert(t, "part1 = 514579", output[0])
  utils.Assert(t, "part2 = 241861950", output[1])
}
