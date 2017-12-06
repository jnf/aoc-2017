defmodule D5 do
  @doc """
  iex> File.read!("input") |> D5.walk
  372671

  iex> D5.walk "0\\n3\\n0\\n1\\n-3"
  5
  """
  def walk(tape), do: walk(prep(tape), {0, 0})
  def walk(tape, {steps, instruction}) when instruction >= tuple_size(tape), do: steps
  def walk(tape, {steps, instruction}) do
    current = elem tape, instruction
    tape = tape
      |> Tuple.delete_at(instruction)
      |> Tuple.insert_at(instruction, current + 1)

    walk(tape, {steps + 1, current + instruction})
  end

  defp prep(tape) do
    tape
      |> String.trim
      |> String.split(~r/\n+/)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
  end
end
