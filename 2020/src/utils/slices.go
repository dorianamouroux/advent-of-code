package utils

func Filter[Item interface{}](list []Item, fn func(Item)bool) []Item {
  var newList []Item

  for _, item := range list {
    if fn(item) {
      newList = append(newList, item)
    }
  }

  return newList
}

func Map[Input interface{}, Output interface{}](list []Input, fn func(Input)Output) []Output {
  var newList []Output

  for _, item := range list {
    newList = append(newList, fn(item))
  }

  return newList
}

func Count[Item interface{}](list []Item, fn func(Item)bool) int {
  count := 0

  for _, item := range list {
    if fn(item) {
      count++
    }
  }

  return count
}

func Max(list []int)int {
  max := list[0]

  for i := 1; i < len(list); i++ {
    if list[i] > max {
      max = list[i]
    }
  }

  return max
}

func Sum(list []int)int {
  total := 0
  for _, nb := range list {
    total += nb
  }
  return total
}
