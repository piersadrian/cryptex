defmodule Util do
  @doc """
  Constructs a repeating string from a repeated value and a desired key size.

      iex> Util.repeating("e", 10)
      "eeeeeeeeee"

      iex> Util.repeating("asdf", 10)
      "asdfasdfas"

      iex> Util.repeating("61736466", 12)
      "617364666173"
  """
  def repeating(repeated_value, size) do
    chunk_size = div(size, String.length(repeated_value))

    repeated_value
    |> String.duplicate(chunk_size + 1)
    |> String.slice(0, size)
  end
end
