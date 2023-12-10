class TwoDimMap
  @@data = []
  def initialize(file)
     @data = file.readlines.map {|line| line.strip!.split("")}
  end

  def at(x, y)
    unless x < 0 or x >= @data[0].length or y < 0 or y >= @data.length
      @data[y][x]
    end
  end

  def edge_adjacent_cells(from_x, from_y)
    [
      [from_x, from_y - 1],
      [from_x, from_y + 1],
      [from_x - 1, from_y],
      [from_x + 1, from_y],
    ]
  end

  def diag_adjacent_cells(from_x, from_y)
    [
      [from_x - 1, from_y - 1],
      [from_x - 1, from_y + 1],
      [from_x + 1, from_y - 1],
      [from_x + 1, from_y + 1],
    ]
  end

  def all_adjacent_cells(from_x, from_y)
    edge_adjacent_cells(from_x, from_y) + diag_adjacent_cells(from_x, from_y)
  end
end
