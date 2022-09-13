package main

import (
  "fmt"
  "strings"
  "strconv"
  "sort"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func decode(code string) (int) {
  code = strings.ReplaceAll(code, "B", "1")
  code = strings.ReplaceAll(code, "F", "0")
  code = strings.ReplaceAll(code, "R", "1")
  code = strings.ReplaceAll(code, "L", "0")

  row, _ := strconv.ParseInt(code[0:7], 2, 32)
  column, _ := strconv.ParseInt(code[7:], 2, 32)
  seatId := row * 8 + column

  return int(seatId)
}

func part1(seatIds []int) int {
  return utils.Max(seatIds)
}

func part2(seatIds []int) int {
  sort.Ints(seatIds)
  for i := 1; i < len(seatIds) -1; i++ {
    if seatIds[i] + 1 != seatIds[i + 1] {
      return seatIds[i] + 1
    }
  }
  return -1
}

func main() {
  file := utils.ReadInput()
  seatIds := utils.Map(file, decode)
  fmt.Println("part1 =", part1(seatIds))
  fmt.Println("part2 =", part2(seatIds))
}
