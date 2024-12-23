defmodule Aoc.Day13 do
  @day "13"
  @delta_p_2 10000000000000

  def part_1(path) do
    path
    |> parse()
    |> compute_games()
    |> IO.inspect(label: path)
  end

  def part_2(path) do
    path
    |> parse()
    |> Enum.map(fn %{result: {result_x, result_y}} = game ->
      Map.put(game, :result, {result_x + @delta_p_2, result_y + @delta_p_2})
    end)
    |> compute_games()
    |> IO.inspect(label: path)
  end

  def main() do
    IO.inspect("part 1")
    part_1("inputs/day#{@day}_example.txt")
    part_1("inputs/day#{@day}_input.txt")

    IO.inspect("part 2")
    part_2("inputs/day#{@day}_example.txt")
    part_2("inputs/day#{@day}_input.txt")
  end

  defp compute_games(games) do
    games
    |> Enum.map(fn game ->
      # Shameless-ly using Nx to solve my linear algebra (i can't math)

      a = Nx.tensor([
        [elem(game.button_a, 0), elem(game.button_b, 0)],
        [elem(game.button_a, 1), elem(game.button_b, 1)],
      ], type: {:f, 64})

      b = Nx.tensor(Tuple.to_list(game.result), type: {:f, 64})

      [nb_press_a, nb_press_b] = Nx.LinAlg.solve(a, b)
      |> Nx.round
      |> Nx.to_flat_list()
      |> Enum.map(&round/1)

      # Solutions from NX maybe not work because they are not dealing with integer
      # We double check that it adds up
      if check_solution(game, nb_press_a, nb_press_b) do
        (nb_press_a * 3) + nb_press_b
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  defp check_solution(game, nb_press_a, nb_press_b) do
    {result_x, result_y} = game.result
    {button_a_x, button_a_y} = game.button_a
    {button_b_x, button_b_y} = game.button_b

    valid_x = result_x == (nb_press_a * button_a_x) + (nb_press_b * button_b_x)
    valid_y = result_y == (nb_press_a * button_a_y) + (nb_press_b * button_b_y)
    valid_x && valid_y
  end

  defp parse(path) do
    path
    |> Aoc.Parser.two_chunks()
    |> Enum.map(fn game ->
      [a, b, c, d, e, f] = ~r/[0-9]+/
      |> Regex.scan(game)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

      %{
        raw_str: game,
        button_a: {a, b},
        button_b: {c, d},
        result: {e, f}
      }
    end)
  end
end
