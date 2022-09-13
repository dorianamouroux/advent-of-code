package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type room struct {
  width int
  height int
  data []string
}

func (r room) is_in_room(x int, y int)bool {
  return x >= 0 && y >= 0 && x < r.width && y < r.height
}

func (r room) at_pos(x int, y int)string {
  if r.is_in_room(x, y) {
    return string(r.data[y][x])
  }
  return "."
}

func countAdjacentOccupied(r room, x int, y int)int {
  countOccupied := 0
  for i := x - 1; i <= x + 1; i++ {
    for j := y - 1; j <= y + 1; j++ {
      if r.at_pos(i, j) == "#" {
        countOccupied++
      }
    }
  }
  return countOccupied
}

func countVisualOccupied(r room, x int, y int)int {
  directions := [][]int{
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1},
  }

  // explore each direction until a #, stop on first L or if out of the map
  return utils.Count(directions, func (direction []int)bool {
    i, j := x, y
    for {
      i += direction[0]
      j += direction[1]
      at_pos := r.at_pos(i, j)
      if r.is_in_room(i, j) == false || at_pos == "L" {
        return false
      }
      if at_pos == "#" {
        return true
      }
    }
  })
}

func (r room) doLoopUntilStable(occupiedFn func(room, int, int)int)room {
  for {
    newData := make([]string, 0)
    for y := 0; y < r.height; y++ {
      newLine := ""
      for x := 0; x < r.width; x++ {
        currentLetter := r.at_pos(x, y)
        aroundOccupied := occupiedFn(r, x, y)
        if currentLetter == "L" && aroundOccupied == 0 { // free seat, nothing around
          newLine += "#"
        } else if currentLetter == "#" && aroundOccupied >= 5 {
          newLine += "L"
        } else {
          newLine += currentLetter
        }
      }
      newData = append(newData, newLine)
    }
    if strings.Join(r.data, "") == strings.Join(newData, "") {
      return room{width: r.width, height: r.height, data: newData}
    }
    r.data = newData
  }
}

func part1(r room) int {
  r = r.doLoopUntilStable(countAdjacentOccupied)
  return strings.Count(strings.Join(r.data, ""), "#")
}

func part2(r room) int {
  r = r.doLoopUntilStable(countVisualOccupied)
  return strings.Count(strings.Join(r.data, ""), "#")
}

func main() {
  file, errFile := utils.ReadInput()
  room := room{width: len(lines[0]), height: len(lines), data: file}
  if errFile != nil {
    fmt.Println(errFile)
    return
  }
  fmt.Println("part1 =", part1(room))
  fmt.Println("part2 =", part2(room))
}
