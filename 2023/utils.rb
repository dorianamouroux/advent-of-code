class TwoDimMap
  @@data = []
  def initialize(lines)
     @data = lines.map {|line| line.strip.split("")}
  end

  def at(x, y)
    unless x < 0 or x >= @data[0].length or y < 0 or y >= @data.length
      @data[y][x]
    end
  end

  def lines
    @data.map{|line| line}
  end

  def columns
    (0..@data[0].length - 1).map {|x| lines.map{|line| line[x]}}
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

  def find(symbol)
    each_cell.find {|x, y| symbol == at(x, y)}
  end

  def each_cell
    return to_enum(__method__) unless block_given?

    (0..@data.length).each {|y|
      (0..@data[0].length).each {|x|
        yield [x, y]
      }
    }
  end
end
