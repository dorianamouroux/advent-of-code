package main

import (
  "fmt"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)


func part1(lines []int) int {
  nbLines := len(lines)
  for i := 0; i < nbLines - 1; i++ {
    for j := i + 1; j < nbLines; j++ {
      if lines[i] + lines[j] == 2020 {
        return lines[i] * lines[j]
      }
    }
  }
  return -1
}

func part2(lines []int) int {
  nbLines := len(lines)
  for i := 0; i < nbLines - 2; i++ {
    for j := i + 1; j < nbLines - 1; j++ {
      for k := j + 1; k < nbLines; k++ {
        if lines[i] + lines[j] + lines[k] == 2020 {
          return lines[i] * lines[j] * lines[k]
        }
      }
    }
  }
  return -1
}

func main() {
  file, errFile := utils.ReadInput()
  if errFile != nil {
    fmt.Println(errFile)
    return
  }
  data := utils.AtoiSlice(file)
  fmt.Println("part1 =", part1(data))
  fmt.Println("part2 =", part2(data))
}
