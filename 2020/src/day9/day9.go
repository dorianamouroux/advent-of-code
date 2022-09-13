package main

import (
  "fmt"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func respectCondition(template []int, number int)bool {
  nbLines := len(template)
  for i := 0; i < nbLines - 1; i++ {
    for j := i + 1; j < nbLines; j++ {
      if template[i] + template[j] == number {
        return true
      }
    }
  }
  return false
}

func part1(numbers []int, batchSize int) int {
  for i := batchSize; i < len(numbers); i++ {
    previousNumber := numbers[i - batchSize:i]
    if !respectCondition(previousNumber, numbers[i]) {
      return numbers[i]
    }
  }
  return -1
}

func part2(numbers []int, wrongNumber int) int {
  for i := 0; i < len(numbers); i++ {
    var numbersInChain []int
    nb := 0
    for j := i; nb < wrongNumber || len(numbersInChain) < 2; j++ {
      nb += numbers[j]
      numbersInChain = append(numbersInChain, numbers[j])
    }
    if nb == wrongNumber {
      return utils.Min(numbersInChain) + utils.Max(numbersInChain)
    }
  }

  return -1
}

func main() {
  file := utils.ReadInput()
  fileInts := utils.Map(file, utils.AtoiSimple)
  resPart1 := part1(fileInts, 25)
  fmt.Println("part1 =", resPart1)
  fmt.Println("part2 =", part2(fileInts, resPart1))
}
