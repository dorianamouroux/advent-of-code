package utils

import (
  "regexp"
  "strconv"
)

func IsBetweenString(s string, a int, b int) bool {
  nb, err := strconv.Atoi(s)
  if err != nil {
    return false
  }
  return nb >= a && nb <= b
}

func Regex(p string, s string)bool {
  match, _ := regexp.MatchString(p, s)
  return match
}

func IsHexadecimalColor(s string)bool {
  return Regex("^#([a-f0-9]{6})$", s)
}

func IsOneOf(s string, options []string)bool {
  for _, value := range options {
    if s == value {
      return true
    }
  }
  return false
}
