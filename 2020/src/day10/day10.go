package main

import (
  "fmt"
  "sort"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func part1(numbers []int) int {
  var differences = make(map[int]int)

  numbers = append(numbers, 0) // the wall
  numbers = append(numbers, utils.Max(numbers) + 3) // the device
  sort.Ints(numbers)

  for i := 0; i < len(numbers) - 1; i++ {
    diffWithNext := numbers[i + 1] - numbers[i]
    value, present := differences[diffWithNext]
    if present {
      differences[diffWithNext] = value + 1
    } else {
      differences[diffWithNext] = 1
    }
  }

  return differences[1] * differences[3]
}

func canConnect(right int, left int)bool {
  diff := right - left
  return diff > 0 && diff < 4
}

func getAllPath(numbers []int, currentValue int, cache map[int]int) int {
  connectables := utils.Filter(numbers, func (nb int)bool {
    return canConnect(nb, currentValue)
  })
  countValidPath := 0

  if len(connectables) == 0 {
    return 1
  }

  for _, connectable := range connectables {
    if valueInCache, ok := cache[connectable]; ok == true {
      countValidPath += valueInCache
    } else {
      countValidPath += getAllPath(numbers, connectable, cache)
    }
  }

  cache[currentValue] = countValidPath

  return countValidPath
}

func part2(numbers []int) int {
  cache := make(map[int]int)
  return getAllPath(numbers, 0, cache)
}

func main() {
  file := utils.ReadInput()
  numbers := utils.Map(file, utils.AtoiSimple)
  fmt.Println("part1 =", part1(numbers))
  fmt.Println("part2 =", part2(numbers))
}
