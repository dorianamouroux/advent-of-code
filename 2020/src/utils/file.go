package utils

import (
  "os"
  "strings"
  "flag"
  "errors"
)

func ReadInput() ([]string, error) {
  input := flag.String("input", "", "The path of the input file")

  flag.Parse()

  if *input == "" {
    return nil, errors.New("Please give -input=path")
  }

  return readFile(*input)
}

func readFile(path string) ([]string, error) {
  data, err := os.ReadFile(path)
  if err != nil {
    return nil, err
  }
  return bytesToLineString(data), nil
}

func bytesToLineString(str []byte) ([]string) {
  lines := strings.Split(string(str), "\n")
  return Filter[string](lines, func (s string)bool {
    return !isEmpty(s)
  })
}

func isEmpty(str string) bool {
  return strings.Trim(str, "\n\t ") == ""
}
