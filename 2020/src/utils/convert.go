package utils

import (
  "strconv"
)

func AtoiSimple(s string)int {
  nb, err := strconv.Atoi(s)
  if err != nil {
    panic(err)
  }
  return nb
}

func AtoiSlice(lines []string) []int {
  return Map[string, int](lines, AtoiSimple)
}
