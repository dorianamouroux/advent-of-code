defmodule Day7 do
  def main() do
    example = parse("example.txt")
    IO.inspect("Part 1 example = #{part1(example)}")
    IO.inspect("Part 2 example = #{part2(example)}")

    input = parse("input.txt")
    IO.inspect("Part 1 input = #{part1(input)}")
    IO.inspect("Part 2 input = #{part2(input)}")
  end

  def parse(filename) do
    file_system = %{current_path: nil, files: %{}}

    filename
    |> File.read!()
    |> String.split("$ ", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(file_system, fn line, file_system  ->
      case line do
        "cd /" ->
          Map.put(file_system, :current_path, "/")
        "cd .." ->
          new_path = Path.dirname(file_system.current_path)
          Map.put(file_system, :current_path, new_path)
        "cd " <> folder ->
          new_path = Path.join(file_system.current_path, folder)
          Map.put(file_system, :current_path, new_path)
        "ls\n" <> content ->
          dest = [:files] ++ Path.split(file_system.current_path)
          files = content
          |> String.split("\n")
          |> Map.new(fn
            "dir " <> dir_name -> {dir_name, %{}}
            file ->
              [size|filename] = String.split(file, " ")
              {List.first(filename), String.to_integer(size)}
          end)
          put_in(file_system, dest, files)
      end
    end)
    |> Map.get(:files)
    |> Map.get("/")
  end

  def part1(files) do
    cache = :ets.new(:user_lookup, [:set, :protected])

    compute_size_folder(cache, "/", files)

    :ets.match(cache, {:_, :"$1"})
    |> List.flatten()
    |> Enum.reject(& &1 > 100_000)
    |> Enum.sum()
  end

  def part2(files) do
    cache = :ets.new(:user_lookup, [:set, :protected])

    total_size = compute_size_folder(cache, "/", files)
    needed_space = abs(7_0000_000 - total_size - 30000000)

    :ets.match(cache, {:_, :"$1"})
    |> List.flatten()
    |> Enum.reject(& &1 < needed_space)
    |> Enum.sort()
    |> List.first()
  end

  def compute_size_folder(cache, path, folder) do
    {files, folders} = Enum.split_with(folder, fn {_, content} -> is_integer(content) end)

    size_files = files
    |> Enum.map(fn {_, value} -> value end)
    |> Enum.sum()

    size_folders = folders
    |> Enum.map(fn {folder_name, content} ->
      compute_size_folder(cache, Path.join(path, folder_name), content)
    end)
    |> Enum.sum()

    total_size = size_files + size_folders

    :ets.insert(cache, {path, total_size})

    total_size
  end

end

Day7.main()
