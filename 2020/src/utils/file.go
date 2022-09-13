package utils

import (
  "os"
  "fmt"
  "strings"
  "flag"
)

func ReadInput() ([]string) {
  file := ReadFileInput()

  return FileToLines(string(file))
}

func ReadFileInput() ([]byte) {
  path := flag.String("input", "", "The path of the input file")

  flag.Parse()

  if *path == "" {
    fmt.Println("Please give -input=path")
    os.Exit(1)
  }

  file, errFile := os.ReadFile(*path)
  if errFile != nil {
    fmt.Println(errFile)
    os.Exit(1)
  }
  return file
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
