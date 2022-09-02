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
