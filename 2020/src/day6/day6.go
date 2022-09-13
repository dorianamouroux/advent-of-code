package main

import (
  "fmt"
  "strings"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func getAnswersCount(group string) map[string]int {
  group = strings.Trim(group, "\t \n")
  forms := strings.Split(group, "\n")
  var counts = make(map[string]int)
  counts["_group_size"] = len(forms)

  for _, form := range forms {
    for i := 0; i < len(form); i++{
      letter := string(form[i])
      value, present := counts[letter]
      if present {
        counts[letter] = value + 1
        } else {
          counts[letter] = 1
        }
      }
  }

  return counts
}

func part1(answerPerGroup []map[string]int) int {
  answerCountPerGroup := utils.Map(answerPerGroup, func (answers map[string]int)int {
    return len(answers) - 1
  })
  return utils.Sum(answerCountPerGroup)
}

func part2(answerPerGroup []map[string]int) int {
  answerCountPerGroup := utils.Map(answerPerGroup, func (answers map[string]int)int {
    countAllCheck := 0
    for key, nbCheck := range answers {
      if key == "_group_size" {
        continue
      }
      if nbCheck == answers["_group_size"] {
        countAllCheck++
      }
    }
    return countAllCheck
  })
  return utils.Sum(answerCountPerGroup)
}

func main() {
  file := utils.ReadFileInput()
  inputs := strings.Split(string(file), "\n\n")
  answerPerGroup := utils.Map(inputs, getAnswersCount)
  fmt.Println("part1 =", part1(answerPerGroup))
  fmt.Println("part2 =", part2(answerPerGroup))
}
