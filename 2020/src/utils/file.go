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
  strList := strings.Trim(string(str), " \n\t")
  return strings.Split(strList, "\n")
}
