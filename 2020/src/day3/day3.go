package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func downTheSlope(terrain [][]string, incRight int, incDown int)int {
  nbTree := 0
  x := 0
  for y := 0; y < len(terrain); y += incDown {
    line := terrain[y]
    if line[x % len(line)] == "#" {
      nbTree++
    }
    x = x + incRight
  }
  return nbTree
}

func part1(terrain [][]string) int {
  return downTheSlope(terrain, 3, 1)
}

func part2(terrain [][]string) int {
  return downTheSlope(terrain, 1, 1) *
    downTheSlope(terrain, 3, 1) *
    downTheSlope(terrain, 5, 1) *
    downTheSlope(terrain, 7, 1) *
    downTheSlope(terrain, 1, 2)
}

func main() {
  file, errFile := utils.ReadInput()
  if errFile != nil {
    fmt.Println(errFile)
    return
  }
  terrain := utils.Map[string, []string](file, func (s string) []string {
    return strings.Split(s, "")
  })
  fmt.Println("part1 =", part1(terrain))
  fmt.Println("part2 =", part2(terrain))
}
