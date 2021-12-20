defmodule Day4 do

  def main() do
    {inputs, boards} = Parsing.read_file()

    {final_number, winning_board} = draw_numbers(boards, inputs)
    sum_unmarked_numbers = Board.sum_unmarked_numbers(winning_board)

    IO.inspect(sum_unmarked_numbers * final_number)
  end

  def draw_numbers(boards, []), do: boards

  def draw_numbers(boards, [drawn_number | rest]) do
    boards_with_number = Board.put_number(boards, drawn_number)
    case Board.get_winning_board(boards_with_number) do
      nil -> draw_numbers(boards_with_number, rest)
      board -> {drawn_number, board}
    end
  end
end

defmodule Board do

  def sum_unmarked_numbers(board) do
    board
    |> Enum.filter(fn {_, drawn} -> drawn == false end)
    |> Enum.map(fn {number, _} -> number end)
    |> Enum.sum()
  end

  def get_winning_board(boards) do
    Enum.find(boards, &has_won/1)
  end

  def has_won(board) do
    two_dim_board = Enum.chunk_every(board, 5)

    has_won_horizontal = two_dim_board
    |> Enum.any?(&line_won/1)

    has_won_vertical = two_dim_board
    |> list_of_cols()
    |> Enum.any?(&line_won/1)

    has_won_horizontal or has_won_vertical
  end

  def list_of_cols(board) do
    nb_cols = Enum.count(board)
    range = 0..(nb_cols - 1)
    Enum.map(range, fn i ->
      Enum.map(board, &(Enum.at(&1, i)))
    end)
  end

  def line_won(line) do
    Enum.all?(line, fn {_, was_drawn} -> was_drawn end)
  end

  def put_number(boards, number) do
    Enum.map(boards, &(put_number_in_board(&1, number)))
  end

  def put_number_in_board(board, drawn_number) do
    Enum.map(board, fn {number, _} = line ->
      case drawn_number do
        ^number -> {number, true}
        _ -> line
      end
    end)
  end

end

defmodule Parsing do
  def read_file() do
    file = raw_file()
    [numbers_to_draw | raw_boards] = file
    {parse_numbers(numbers_to_draw), parse_boards(raw_boards)}
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(",")
    |> Enum.map(&string_to_int/1)
  end

  defp parse_boards(boards) do
    boards
    |> Enum.map(&parse_line_board/1)
    |> Enum.chunk_every(5)
    |> Enum.map(&List.flatten/1)
  end

  defp parse_line_board(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&string_to_int/1)
    |> Enum.map(fn number -> {number, false} end)
  end

  defp raw_file() do
    [filename] = System.argv()
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
  end

  defp string_to_int(str) do
    {number, _} = Integer.parse(str)
    number
  end
end

Day4.main()
