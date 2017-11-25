defmodule Bits do
  require Bitwise

  @doc """
  Performs a bitwise XOR of the given hex strings and returns the resulting hex string. The given
  hex strings must have the same length or an error will be raised.

      iex> Bits.xor("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965")
      "746865206B696420646F6E277420706C6179"
  """
  def xor(hex1, hex2) when byte_size(hex1) == byte_size(hex2) do
    with left <- Base.decode16!(hex1, case: :mixed),
         right <- Base.decode16!(hex2, case: :mixed),
         do: xor_bitstrings(left, right)
  end

  def xor(_, _), do: raise(ArgumentError, message: "hex strings don't have the same length")

  defp xor_bitstrings(hex1, hex2) do
    zipped_bytes =
      with left_list <- :binary.bin_to_list(hex1),
           right_list <- :binary.bin_to_list(hex2),
           do: Enum.zip(left_list, right_list)

    zipped_bytes
    |> Enum.map(fn {l, r} -> Bitwise.bxor(l, r) end)
    |> :binary.list_to_bin()
    |> Base.encode16()
  end
end
