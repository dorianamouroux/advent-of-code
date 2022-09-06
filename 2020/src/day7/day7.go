package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)
type graph map[string]map[string]int

func parse(lines []string) graph {
  var bags = make(graph)

  for _, definition := range lines {
    name, capacityDef, _ := strings.Cut(definition, " bags contain ")
    capacities := strings.Split(strings.Trim(capacityDef, "."), ", ")
    capacities = utils.Filter(capacities, func (capacity string)bool {
      return capacity != "no other bags"
    })
    bags[name] = make(map[string]int)
    for _, capacity := range capacities {
      count := utils.AtoiSimple(string(capacity[0]))
      bagName := strings.Trim(capacity[1:], " ")
      bagName = strings.ReplaceAll(bagName, " bags", "")
      bagName = strings.ReplaceAll(bagName, " bag", "")
      bags[name][bagName] = count
    }
  }

  return bags
}

func canContainBag(bags graph, bagName string, toFind string)bool {
  for bagToCheck, _ := range bags[bagName] {
    if bagToCheck == toFind || canContainBag(bags, bagToCheck, toFind) {
      return true
    }
  }

  return false
}

func part1(bags graph, toFind string) int {
  count := 0
  for bag, _ := range bags {
    if canContainBag(bags, bag, toFind) {
      count += 1
    }
  }
  return count
}

func sumNbBag(bags graph, bagToCount string) int {
  nbBag := 1
  for bagName, count := range bags[bagToCount] {
    nbBag += count * sumNbBag(bags, bagName)
  }
  return nbBag
}

func part2(bags graph, bagToCount string) int {
  return sumNbBag(bags, bagToCount) - 1
}

func main() {
  file, errFile := utils.ReadInput()
  if errFile != nil {
    fmt.Println(errFile)
    return
  }
  bags := parse(file)
  fmt.Println("part1 =", part1(bags, "shiny gold"))
  fmt.Println("part2 =", part2(bags, "shiny gold"))
}
