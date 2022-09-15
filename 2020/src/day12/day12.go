package main

import (
  "fmt"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type position struct {
  x int
  y int
  direction string
}

func (p *position) rotate(angle int) {
  order := []string{"W", "N", "E", "S"}
  currentPos := utils.FindIndex(order, p.direction)
  newIndex := ((angle / 90) + currentPos) % len(order)
  p.direction = order[newIndex]
}

func (p *position) rotateAround(angle int) {
  nbRotation := angle / 90
  for i := 0; i < nbRotation; i++ {
    p.x, p.y = p.y, p.x * -1
  }
}

func part1(lines []string) int {
  pos := position{x: 0, y: 0, direction: "E"}

  for _, line := range lines {
    order := string(line[0])
    value := utils.AtoiSimple(line[1:])
    if order == "F" {
      order = pos.direction
    }
    switch order {
      case "N":
        pos.y += value
      case "S":
        pos.y -= value
      case "E":
        pos.x += value
      case "W":
        pos.x -= value
      case "L":
        pos.rotate(360 - value)
      case "R":
        pos.rotate(value)
    }
  }
  return utils.Abs(pos.x) + utils.Abs(pos.y)
}

func part2(lines []string) int {
  ship := position{x: 0, y: 0}
  waypoint := position{x: 10, y: 1}

  for _, line := range lines {
    order := string(line[0])
    value := utils.AtoiSimple(line[1:])
    switch order {
      case "N":
        waypoint.y += value
      case "S":
        waypoint.y -= value
      case "E":
        waypoint.x += value
      case "W":
        waypoint.x -= value
      case "L":
        waypoint.rotateAround(360 - value)
      case "R":
        waypoint.rotateAround(value)
      case "F":
        ship.x += value * waypoint.x
        ship.y += value * waypoint.y
    }
  }
  return utils.Abs(ship.x) + utils.Abs(ship.y)
}

func main() {
  file := utils.ReadInput()
  fmt.Println("part1 =", part1(file))
  fmt.Println("part2 =", part2(file))
}
