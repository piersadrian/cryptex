defmodule Analyze do
  defmodule Frequency do
    @doc """
    Performs English letter-frequency analysis to brute-force a single-character key.

        iex> Analyze.Frequency.attempt_decrypt("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")
        "Cooking MC's like a pound of bacon"
    """
    def attempt_decrypt(ciphertext) do
      Enum.map(?A..?z, fn char ->
        with plaintext <- single_char_decrypt(ciphertext, char),
             score <- score_plaintext(plaintext),
             do: {char, score, plaintext}
      end)
      |> Enum.sort_by(fn tuple -> elem(tuple, 1) end, &>=/2)
      |> hd()
      |> elem(2)
    end

    defp single_char_decrypt(ciphertext, single_char_key) do
      single_char_key
      |> Integer.to_string(16)
      |> Util.repeating(String.length(ciphertext))
      |> Bits.xor(ciphertext)
      |> Base.decode16!()
    end

    @frequency_chars ' eEtTaAoOiInNsShHrRdDlLcCuUmMwWfFgGyYpPbBvVkKjJxXqQzZ'

    defp score_plaintext(plaintext) do
      @frequency_chars
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {char, index}, score ->
           score + :math.pow(character_frequency(plaintext, char), index)
         end)
    end

    defp character_frequency(plaintext, char) do
      plaintext
      |> String.to_charlist()
      |> Enum.reduce(0, fn
           plaintext_char, frequency when plaintext_char == char ->
             frequency + 1

           plaintext_char, frequency ->
             frequency
         end)
    end
  end
end
