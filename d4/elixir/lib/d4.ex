defmodule D4 do
  @doc """
    iex> D4.validate("input")
    466

    iex> D4.validate("input", %{sort: true})
    251
  """
  def validate(file, opts \\ %{}) do
    config = %{sort: false } |> Map.merge(opts)
    File.stream!(file, [:utf8])
      |> Stream.map(&(valid?(&1, config)))
      |> Enum.filter(&(&1))
      |> length
  end

  @doc """
    iex> D4.valid? "aa bb cc dd ee"
    true

    iex> D4.valid? "aa bb cc dd aa"
    false

    iex> D4.valid? "aa bb cc dd aaa"
    true

    iex> D4.valid? "abcde xyz ecdab", %{sort: true}
    false
  """
  def valid?(line, opts \\ %{}) do
    config = %{sort: false} |> Map.merge(opts)
    line
      |> String.split(~r/\s+/, trim: true)
      |> (fn (l) -> if(config.sort, do: Enum.map(l, &sorter/1), else: l) end).()
      |> (fn (l) -> length(Enum.uniq(l)) === length l end).()
  end

  defp sorter(word) do
    word
      |> String.split(~r{}, trim: true)
      |> Enum.sort
      |> to_string
  end
end
