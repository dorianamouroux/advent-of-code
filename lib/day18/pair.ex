defmodule Day18.Pair do
  def new(left, right, parent \\ nil) do
    %{
      left: left,
      right: right,
      parent: parent,
      id: generate_id()
    }
  end

  def number_pair?(pair), do: is_number(pair.left) and is_number(pair.right)
  def should_split?(nb), do: is_number(nb) and nb >= 10

  defp generate_id() do
    min = String.to_integer("100000000", 36)
    max = String.to_integer("ZZZZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end
end
