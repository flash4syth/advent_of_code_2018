defmodule Day2Part2 do
  @moduledoc """
  Documentation for Day2.
  """

  def find_single_differing_strings(file_content) do
      file_content
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(&Kernel.to_charlist/1)
      |> find_match()
  end

  defp find_match([candidate | rest]) do
    Enum.find_value(rest, &find_one_difference(&1, candidate)) ||
      find_match(rest)
  end

  defp find_one_difference(charlist1, charlist2) do
    find_one_difference(charlist1, charlist2, [], 0)
  end

  defp find_one_difference([_ | tail1], [_ | tail2], same_acc, difference_count)
  when difference_count > 1 do
    nil
  end
  defp find_one_difference([head | tail1], [head | tail2], same_acc, difference_count) do
    find_one_difference(tail1, tail2, [head | same_acc], difference_count)
  end
  defp find_one_difference([_ | tail1], [_ | tail2], same_acc, difference_count) do
    find_one_difference(tail1, tail2, same_acc, difference_count + 1)
  end
  defp find_one_difference([], [], same_acc, 1) do
    same_acc |> Enum.reverse |> to_string
  end
  defp find_one_difference([], [], same_acc, _) do
    nil
  end

  defp one_letter?([str]) when is_binary(str) do
  end
  defp one_letter?(_), do: false
end
