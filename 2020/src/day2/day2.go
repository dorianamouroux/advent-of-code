package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type password struct {
  minLength int
  maxLength int
  letter string
  value string
}

func parseItem(s string) password {
  // split by ": ", params on left, value on right
  first_split := strings.Split(s, ": ")
  params, value := first_split[0], first_split[1]

  // split by " ", sizes on left, params on right
  second_split := strings.Split(params, " ")
  sizes, letter := second_split[0], second_split[1]

  // you got it
  third_split := utils.AtoiSlice(strings.Split(sizes, "-"))
  minLength, maxLength := third_split[0], third_split[1]

  return password{minLength, maxLength, letter, value}
}

func isPasswordValidPart1(p password) bool {
  nbLetter := strings.Count(p.value, p.letter)
  return nbLetter >= p.minLength && nbLetter <= p.maxLength
}

func isPasswordValidPart2(p password) bool {
  firstChar := string(p.value[p.minLength - 1])
  secondChar := string(p.value[p.maxLength - 1])

  if firstChar == secondChar {
    return false
  }
  return firstChar == p.letter || secondChar == p.letter
}

func part1(passwords []password) int {
  return utils.Count[password](passwords, isPasswordValidPart1)
}

func part2(passwords []password) int {
  return utils.Count[password](passwords, isPasswordValidPart2)
}

func main() {
  lines, errFile := utils.ReadInput()
  if errFile != nil {
    fmt.Println(errFile)
    return
  }
  data := utils.Map[string, password](lines, parseItem)
  fmt.Println("part1 =", part1(data))
  fmt.Println("part2 =", part2(data))
}
