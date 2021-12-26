defmodule Day24.UAL do
  def compute_with_input(instructions, inputs) do
    registers = %{w: 0, x: 0, y: 0, z: 0, inputs: inputs}
    apply_instructions(registers, instructions)
  end

  defp apply_instructions(registers, []), do: registers
  defp apply_instructions(registers, [current_instruction | next_instructions]) do
    registers
    |> run_instruction(current_instruction)
    |> apply_instructions(next_instructions)
  end

  defp run_instruction(%{inputs: [input | rest_input]} = regs, {:inp, register}) do
    regs
    |> Map.put(register, String.to_integer(input))
    |> Map.put(:inputs, rest_input)
  end

  defp run_instruction(regs, {:add, left, right}) do
    result = get_value(regs, left) + get_value(regs, right)
    Map.put(regs, left, result)
  end

  defp run_instruction(regs, {:mul, left, right}) do
    result = get_value(regs, left) * get_value(regs, right)
    Map.put(regs, left, result)
  end

  defp run_instruction(regs, {:div, left, right}) do
    result = get_value(regs, left) / get_value(regs, right)
    result = if result > 0, do: floor(result), else: ceil(result)
    Map.put(regs, left, floor(result))
  end

  defp run_instruction(regs, {:mod, left, right}) do
    result = rem(get_value(regs, left), get_value(regs, right))
    Map.put(regs, left, result)
  end

  defp run_instruction(regs, {:eql, left, right}) do
    result = if get_value(regs, left) == get_value(regs, right), do: 1, else: 0
    Map.put(regs, left, result)
  end

  # if key isn't a register name, it's a litteral value
  defp get_value(registers, key), do: Map.get(registers, key, key)
end
