package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type passport = map[string]interface{}

func parseItem(line string) passport {
  p := make(passport)
  line = strings.ReplaceAll(line, "\n", " ")
  for _, param := range strings.Split(line, " ") {
    keyValueParam := strings.Split(param, ":")
    if len(keyValueParam) == 2 {
      key := keyValueParam[0]
      value := keyValueParam[1]
      p[key] = value
    }
  }
  return p
}

func hasRequiredField(p passport)bool {
  return utils.HasKey(p, "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
}

func part1(passports []passport) int {
  return utils.Count[passport](passports, hasRequiredField)
}

func part2(_ []string) int {
  return -1
}

func main() {
  file, errFile := utils.ReadFileInput()
  if errFile != nil {
    fmt.Println(errFile)
    return
  }
  inputs := strings.Split(string(file), "\n\n")
  passports := utils.Map[string, passport](inputs, parseItem)
  fmt.Println("part1 =", part1(passports))
  // fmt.Println("part2 =", part2(file))
}
