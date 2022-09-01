package main

import (
  "fmt"
  "os"
  "strings"
  "strconv"
)

func readFile(path string) ([]string, error) {
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

func atoiSlice(lines []string) ([]int, error) {
  linesInt := make([]int, len(lines))
  for i := 0; i < len(lines); i++ {
     nb, err := strconv.Atoi(lines[i])
     if err != nil {
       return nil, err
     }
     linesInt[i] = nb
  }
  return linesInt, nil
}

func part1(lines []int) int {
  nbLines := len(lines)
  for i := 0; i < nbLines - 2; i++ {
    for j := i + 1; j < nbLines - 1; j++ {
      for k := j + 1; k < nbLines; k++ {
        if lines[i] + lines[j] + lines[k] == 2020 {
          return lines[i] * lines[j] * lines[k]
        }
      }
    }
  }
  return -1
}

func main() {
  file, errFile := readFile("src/day1/input.txt")
  if errFile != nil {
    fmt.Println(errFile)
  }
  data, err := atoiSlice(file)
  if err != nil {
    fmt.Println(errFile)
  }
  fmt.Println("part1 = ", part1(data))
}
