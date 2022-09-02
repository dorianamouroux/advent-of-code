package utils

import (
  "os"
  "strings"
)

func ReadFile(path string) ([]string, error) {
  data, err := os.ReadFile(path)
  if err != nil {
    return nil, err
  }
  return bytesToLineString(data), nil
}

func bytesToLineString(str []byte) ([]string) {
  lines := strings.Split(string(str), "\n")
  return Filter(lines, func (s string)bool {
    return !isEmpty(s)
  })
}

func isEmpty(str string) bool {
  return strings.Trim(str, "\n\t ") == ""
}
