defmodule Day10 do

  @closing_tags [">", ")", "}", "]"]
  @pairs ["<>", "()", "{}", "[]"]
  @score %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }

  def main() do
    read_file()
    |> Enum.map(&resolve_symboles/1)
    |> Enum.filter(& String.contains?(&1, @closing_tags))
    |> Enum.map(&compute_score/1)
    |> Enum.sum()
    |> IO.inspect
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

  def compute_score(line) do
    wrong_char = line
    |> String.split("", trim: true)
    |> Enum.find(& Enum.member?(@closing_tags, &1 ))

    Map.get(@score, wrong_char, 0)
  end

  defp read_file() do
    [filename] = System.argv()
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end

Day10.main()