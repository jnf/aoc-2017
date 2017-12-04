defmodule D1 do
  @doc """
    iex> D1.p1_from_file "input"
    1141
  """
  def p1_from_file(path) do
    {:ok, binary} = File.read path
    D1.p1 String.trim(binary)
  end

  @doc """
    iex> D1.p1 "1122"
    3

    iex> D1.p1 "1111"
    4

    iex> D1.p1 "91212129"
    9
  """
  def p1(inputs \\ "") do
    inputs |> String.split(~r{}) |> successive_match_reducer
  end

  defp successive_match_reducer(input) do
    input |>
      adjust_for_circular_list |>
      Enum.chunk_every(2, 1, :discard) |>
      Enum.reduce(%{}, &count/2) |>
      Enum.reduce(0, fn({k, v}, a) -> a + k * v end)
  end

  defp adjust_for_circular_list(list = [head|_tail]) do
    List.replace_at(list, -1, head)
  end

  defp count([_l|[""]], acc), do: acc
  defp count([l|[r]], acc) do
    i = if l == r, do: 1, else: 0
    v = Map.get(acc, to_i(l), 0)
    Map.put(acc, to_i(l), i + v)
  end

  defp to_i(s), do: String.to_integer(s)
end
