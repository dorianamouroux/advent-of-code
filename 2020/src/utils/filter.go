package utils

func Filter(list []string, fn func(string)bool) []string {
  var newList []string

  for _, item := range list {
    if fn(item) {
      newList = append(newList, item)
    }
  }

  return newList
}
