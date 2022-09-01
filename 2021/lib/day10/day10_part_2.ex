defmodule Day10.Part2 do
  @closing_tags [">", ")", "}", "]"]
  @pairs ["<>", "()", "{}", "[]"]
  @score %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  def main(input) do
    read_file(input)
    |> Enum.map(&resolve_symboles/1)
    |> Enum.reject(&String.contains?(&1, @closing_tags))
    |> Enum.map(&get_score_per_line/1)
    |> Enum.sort()
    |> then(fn scores ->
      middle = floor(Enum.count(scores) / 2)
      Enum.at(scores, middle)
    end)
    |> IO.inspect()
  end

  def get_score_per_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.reverse()
    |> Enum.reduce(0, fn letter, total ->
      total * 5 + Map.get(@score, letter, 0)
    end)
  end

  def resolve_symboles(line) do
    if String.contains?(line, @pairs) do
      line
      |> String.replace(@pairs, "")
      |> resolve_symboles()
    else
      line
    end
  end

  defp read_file(input) do
    input
    |> String.split("\n", trim: true)
  end
end
