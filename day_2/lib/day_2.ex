defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  def checksum(file_name) do
    {count2, count3} =
      File.read!(file_name)
      |> String.split(~r/\n/, trim: true)
      |> Enum.reduce({_2_cnt=0, _3_cnt=0}, fn box_id, {cnt2, cnt3} ->
        letter_counts =
        to_charlist(box_id)
        |> Enum.reduce(%{}, fn char, char_map ->
          Map.update(char_map, char, 1, & &1 + 1)
        end)

        {add_count(letter_counts, 2, cnt2), add_count(letter_counts, 3, cnt3)}

      end)

      count2 * count3
  end

  defp add_count(map, int, count) do
    case Enum.find_value(map, fn {_key, val} -> val == int end) do
      true -> count + 1
      nil -> count
    end
  end
end
