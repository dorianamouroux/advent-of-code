package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func assertCode(t *testing.T, code string, expectedSeatId int) {
  seatId := decode(code)
  utils.Assert(t, seatId, expectedSeatId)
}

func TestDecode(t *testing.T) {
  assertCode(t, "BFFFBBFRRR", 567)
  assertCode(t, "FFFBBBFRRR", 119)
  assertCode(t, "BBFFBBFRLL", 820)
}
