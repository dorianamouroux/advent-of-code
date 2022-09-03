package utils

import (
  "os"
  "strings"
  "flag"
  "errors"
)

func ReadInput() ([]string, error) {
  file, errFile := ReadFileInput()
  if errFile != nil {
    return nil, errFile
  }

  return FileToLines(string(file)), nil
}

func ReadFileInput() ([]byte, error) {
  path := flag.String("input", "", "The path of the input file")

  flag.Parse()

  if *path == "" {
    return nil, errors.New("Please give -input=path")
  }

  return os.ReadFile(*path)
}

func FileToLines(str string) ([]string) {
  lines := strings.Split(string(str), "\n")
  return Filter[string](lines, func (s string)bool {
    return !isEmpty(s)
  })
}

func isEmpty(str string) bool {
  return strings.Trim(str, "\n\t ") == ""
}
