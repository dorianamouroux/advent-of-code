package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type instruction struct {
  name string
  value int
  wasRan bool
}

// return the accumulator value, and boolean to indicate if it had infinite loop
func runProgram(instructions []*instruction) (int, bool) {
  currentLine, accumulator := 0, 0

  for currentLine < len(instructions) {
    instruction := instructions[currentLine]
    if instruction.wasRan {
      return accumulator, true
    }
    instruction.wasRan = true
    switch instruction.name {
    case "jmp":
      currentLine = currentLine + instruction.value
    case "acc":
      accumulator = accumulator + instruction.value
      currentLine++
    default:
      currentLine++
    }
  }
  return accumulator, false
}

func resetProgram(instructions []*instruction) {
  for _, instruction := range instructions {
    instruction.wasRan = false
  }
}

func part1(instructions []*instruction) int {
  accumulator, _ := runProgram(instructions)
  return accumulator
}

func part2(instructions []*instruction) int {
  for _, instruction := range instructions {
    if instruction.name == "jmp" {
      resetProgram(instructions)
      instruction.name = "nop"
      accumulator, infiniteLoop := runProgram(instructions)
      if !infiniteLoop {
        return accumulator
      }
      instruction.name = "jmp"
    }
  }
  return -1
}

func main() {
  file := utils.ReadInput()
  instructions := utils.Map(file, func (line string)*instruction {
    name, value, _ := strings.Cut(line, " ")
    return &instruction{name: name, value: utils.AtoiSimple(value), wasRan: false}
  })
  fmt.Println("part1 =", part1(instructions))
  fmt.Println("part2 =", part2(instructions))
}
