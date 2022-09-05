package utils

import (
  "testing"
  "os"
  "io/ioutil"
)

func Assert(t *testing.T, expected interface{}, value interface{}) {
  if expected != value {
    _, isString := expected.(string)
    _, isBool := expected.(bool)
    _, isInt := expected.(int)
    if isString {
      t.Errorf("Error = %s; want %s", expected, value)
    }
    if isBool {
      t.Errorf("Error = %t; want %t", expected, value)
    }
    if isInt {
      t.Errorf("Error = %d; want %d", expected, value)
    }
  }
}

func ExecuteDay(f func()) []string {
    oldArgs := os.Args
    defer func() { os.Args = oldArgs }()
    os.Args = []string{"", "-input=example.txt"}

    rescueStdout := os.Stdout
    r, w, _ := os.Pipe()
    os.Stdout = w

    f()

    w.Close()
    out, _ := ioutil.ReadAll(r)
    os.Stdout = rescueStdout

    return FileToLines(string(out))
}
