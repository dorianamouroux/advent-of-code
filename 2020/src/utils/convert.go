package utils

import (
  "strconv"
)

func AtoiSlice(lines []string) []int {
  return Map[string, int](lines, func (s string)int {
    nb, err := strconv.Atoi(s)
    if err != nil {
      return 0
    }
    return nb
  })
}
