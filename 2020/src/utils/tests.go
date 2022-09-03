package utils

import (
  "testing"
  "os"
  "io/ioutil"
)

func Assert(t *testing.T, expected string, value string) {
  if expected != value {
    t.Errorf("Error = %s; want %s", expected, value)
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
