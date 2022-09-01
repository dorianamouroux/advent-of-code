defmodule Advent.CLI do
  def main([]), do: IO.puts("usage: ./advent --help")

  def main(["--list"]) do
    get_executable_modules()
    |> IO.inspect()
  end

  def main(["--help"]) do
    IO.puts("usage:")
    IO.puts("  ./advent --list")
    IO.puts("  ./advent day12.part1 input.txt")
  end

  def main([day, input]) do
    executable_modules = get_executable_modules()

    module_name =
      day
      |> String.split(".")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join(".")

    day_to_execute =
      Enum.find(executable_modules, fn module ->
        module
        |> to_string()
        |> String.starts_with?("Elixir." <> module_name)
      end)

    if day_to_execute do
      File.read!(input)
      |> day_to_execute.main()
    else
      IO.puts("Wrong day, see --list to find available day")
    end
  end

  defp get_executable_modules() do
    {:ok, list} = :application.get_key(:advent, :modules)

    Enum.filter(list, fn module ->
      Code.ensure_loaded(module)
      module_day? = String.starts_with?(to_string(module), "Elixir.Day")
      has_main? = Kernel.function_exported?(module, :main, 1)
      module_day? and has_main?
    end)
  end
end
