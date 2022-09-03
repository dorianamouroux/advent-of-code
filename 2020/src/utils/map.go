package utils

func HasKey(data map[string]interface{}, keys ...string) bool {
  for _, key := range keys {
    _, isInMap := data[key]
    if !isInMap {
      return false
    }
  }
  return true
}
