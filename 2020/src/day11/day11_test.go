package main

import (
  "testing"

  "github.com/dorianamouroux/advent-of-code/src/utils"
)

func TestCountVisualOccupied(t *testing.T) {
  r := room{
    width: 10,
    height: 3,
    data: []string{
      ".............",
      ".L.L.#.#.#.#.",
      ".............",
    },
  }
  utils.Assert(t, countVisualOccupied(r, 1, 1), 0)
  utils.Assert(t, countVisualOccupied(r, 3, 1), 1)


  r = room{
    width: 10,
    height: 3,
    data: []string{
      ".##.##.",
      "#.#.#.#",
      "##...##",
      "...L...",
      "##...##",
      "#.#.#.#",
      ".##.##.",
    },
  }
  utils.Assert(t, countVisualOccupied(r, 3, 3), 0)

  r = room{
    width: 10,
    height: 3,
    data: []string{
      "###",
      "#.#",
      "###",
    },
  }
  utils.Assert(t, countVisualOccupied(r, 1, 1), 8)
}
