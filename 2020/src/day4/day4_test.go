package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestByr(t *testing.T) {
  validators := getValidators()

  utils.Assert(t, validators["byr"]("2002"), true)
  utils.Assert(t, validators["byr"]("2003"), false)
}

func TestHcl(t *testing.T) {
  validators := getValidators()

  utils.Assert(t, validators["hcl"]("#123abc"), true)
  utils.Assert(t, validators["hcl"]("#123abz"), false)
  utils.Assert(t, validators["hcl"]("123abc"), false)
}

func TestEcl(t *testing.T) {
  validators := getValidators()

  utils.Assert(t, validators["ecl"]("brn"), true)
  utils.Assert(t, validators["ecl"]("wat"), false)
}

func TestHgt(t *testing.T) {
  validators := getValidators()

  utils.Assert(t, validators["hgt"]("60in"), true)
  utils.Assert(t, validators["hgt"]("190cm"), true)
  utils.Assert(t, validators["hgt"]("190in"), false)
  utils.Assert(t, validators["hgt"]("190"), false)
}

func TestDay1(t *testing.T) {
  output := utils.ExecuteDay(main)
  utils.Assert(t, "part1 = 2", output[0])
  utils.Assert(t, "part2 = 2", output[1])
}
