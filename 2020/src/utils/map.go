package utils

func HasKey[V interface{}](data map[string]V, keys ...string) bool {
  for _, key := range keys {
    _, isInMap := data[key]
    if !isInMap {
      return false
    }
  }
  return true
}
