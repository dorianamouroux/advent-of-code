package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

type passport = map[string]string

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
  return utils.HasKey[string](p, "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
}

func getValidators()map[string]func(string)bool {
  return map[string]func(string)bool{
    "byr": func (v string)bool {return utils.IsBetweenString(v, 1920, 2002)},
    "iyr": func (v string)bool {return utils.IsBetweenString(v, 2010, 2020)},
    "eyr": func (v string)bool {return utils.IsBetweenString(v, 2020, 2030)},
    "hcl": utils.IsHexadecimalColor,
    "hgt": func (v string)bool {
      if strings.HasSuffix(v, "in") {
        size, _, _ := strings.Cut(v, "in")
        return utils.IsBetweenString(size, 59, 76)
      }
      if strings.HasSuffix(v, "cm") {
        size, _, _ := strings.Cut(v, "cm")
        return utils.IsBetweenString(size, 150, 193)
      }
      return false
    },
    "ecl": func (v string)bool {
      return utils.IsOneOf(v, []string{"amb", "blu", "brn", "gry", "grn", "hzl", "oth"})
    },
    "pid": func (v string)bool {return utils.Regex("^[0-9]{9}$", v)},
  }
}

func allFieldsValid(p passport) bool {
  validators := getValidators()

  for key, validator := range validators {
    if validator(p[key]) == false {
      return false
    }
  }

  return true
}

func part1(passports []passport) int {
  return utils.Count[passport](passports, hasRequiredField)
}

func part2(passports []passport) int {
  return utils.Count[passport](passports, func (p passport)bool {
    if !hasRequiredField(p) {
      return false
    }
    return allFieldsValid(p)
  })
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
  fmt.Println("part2 =", part2(passports))
}
