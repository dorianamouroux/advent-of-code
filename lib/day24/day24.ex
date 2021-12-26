defmodule Day24 do
  alias Day24.UAL

  @keywords ["inp", "add", "mul", "div", "mod", "eql", "w", "x", "y", "z"]

  def main(input) do
    # brut force algo, but I actually resolved by hand via
    input
    |> parse()
    |> brut_force()
    |> IO.inspect()
  end

  def brut_force(instructions) do
    Enum.find(generate_range(), fn number ->
      inputs = number
      |> Integer.to_string()
      |> String.split("", trim: true)

      if "0" in inputs do
        false
      else
        IO.inspect(inputs, label: "test with")
        case UAL.compute_with_input(instructions, inputs) do
          %{z: 0} -> true
          _ -> false
        end
      end
    end)
  end

  def generate_range() do
    start_nb = "1" |> List.duplicate(14) |> Enum.join |> String.to_integer
    end_nb = "9" |> List.duplicate(14) |> Enum.join |> String.to_integer
    Range.new(end_nb, start_nb, -1)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(fn elem ->
        if Enum.member?(@keywords, elem) do
          String.to_atom(elem)
        else
          String.to_integer(elem)
        end
      end)
      |> List.to_tuple()
    end)
  end
end
