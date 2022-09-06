package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type capacity struct {
  name string
  count int
}

type graph map[string][]capacity

func parse(lines []string) graph {
  var bags = make(graph)

  for _, definition := range lines {
    name, capacityDef, _ := strings.Cut(definition, " bags contain ")
    capacities := strings.Split(strings.Trim(capacityDef, "."), ", ")
    capacities = utils.Filter(capacities, func (capacity string)bool {
      return capacity != "no other bags"
    })
    bags[name] = utils.Map(capacities, func (c string)capacity {
      count := utils.AtoiSimple(string(c[0]))
      c = strings.Trim(c[1:], " ")
      bagName := strings.ReplaceAll(c, " bags", "")
      bagName = strings.ReplaceAll(bagName, " bag", "")
      return capacity{name:bagName, count:count}
    })
  }

  return bags
}

func canContainBag(bags graph, bagName string, toFind string)bool {
  for _, bagToCheck := range bags[bagName] {
    if bagToCheck.name == toFind {
      return true
    }
    if canContainBag(bags, bagToCheck.name, toFind) {
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
  for _, contains := range bags[bagToCount] {
    nbBag += contains.count * sumNbBag(bags, contains.name)
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
