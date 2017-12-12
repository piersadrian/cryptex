defmodule Analyze do
  defmodule Frequency do
    def attempt_decrypt(hex) do
      score_by_frequency(hex, String.length(hex))
      |> Enum.sort_by(fn tuple -> elem(tuple, 1) end, &>=/2)
      |> hd()
      |> elem(2)
    end

    @frequency_chars ' eEtTaAoOiInNsShHrRdDlLcCuUmMwWfFgGyYpPbBvVkKjJxXqQzZ'

    defp score_by_frequency(cipher_hex, key_size) do
      Enum.map(?A..?z, fn char ->
        plaintext =
          Integer.to_string(char, 16)
          |> Util.repeating(key_size)
          |> Bits.xor(cipher_hex)
          |> Base.decode16!()

        score = score_candidate(plaintext)
        {List.to_string([char]), score, plaintext}
      end)
    end

    defp score_candidate(plaintext) do
      @frequency_chars
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {char, index}, score ->
           score + :math.pow(freq(plaintext, char), index)
         end)
    end

    defp freq(plaintext, char) do
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
