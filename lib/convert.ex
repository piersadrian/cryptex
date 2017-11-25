defmodule Convert do
  defmodule Hex do
    @doc """
    Converts a hex string into a base64 string, ignoring hex case.

        iex> Convert.Hex.to_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")
        "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
    """
    def to_base64(hex) do
      hex
      |> String.upcase
      |> Base.decode16!
      |> Base.encode64
    end
  end

  defmodule Base64 do
    def to_hex(base64) do
      base64
      |> Base.decode64!(padding: false)
      |> Base.encode16
      |> String.downcase
    end
  end
end
