package main

import (
  "testing"
  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestRotateAround(t *testing.T) {
  waypoint := position{x:10, y:4}
  waypoint.rotateAround(90)
  utils.Assert(t, waypoint.x, 4)
  utils.Assert(t, waypoint.y, -10)
}
