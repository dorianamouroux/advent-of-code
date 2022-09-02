package utils

import (
  "strconv"
)

func AtoiSlice(lines []string) ([]int, error) {
  linesInt := make([]int, len(lines))
  for i := 0; i < len(lines); i++ {
     nb, err := strconv.Atoi(lines[i])
     if err != nil {
       return nil, err
     }
     linesInt[i] = nb
  }
  return linesInt, nil
}
