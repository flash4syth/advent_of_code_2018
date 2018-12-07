defmodule Day3 do
  @moduledoc """
  Documentation for Day3.
  """

  def claim_overlap_count(claims) do
    claims
    |> String.split(~r/\n/, trim: true)
    |> Stream.map(&claim_parser/1)
    |> Stream.map(&map_claim_to_set/1)
    |> Enum.to_list()
    |> find_intersects(MapSet.new())
  end

  defp claim_parser(claim) do
    ~r/\#
      (?<id>\d+)\s@\s
      (?<left_coord>\d+),
      (?<right_coord>\d+):\s
      (?<width>\d+)x
      (?<height>\d+)
    /x
    |> Regex.named_captures(claim)
  end

  defp map_claim_to_set(%{"left_coord" => str_left, "right_coord" => str_right,
  "width" => str_width, "height" => str_height}) do
    [left, right, width, height] = Enum.map(
      [str_left, str_right, str_width, str_height], fn str ->
      {integer, _} = Integer.parse(str)
      integer
    end)
    for(i <- 1..width, j <- 1..height, do:
      {i + left, j + right})
    |> MapSet.new()
  end

  defp claim_set_with_ids(%{"id" => id} = map) do
    %{"id" => id, "coords" => map_claim_to_set(map)}
  end

  defp find_intersects([], set), do: MapSet.size(set)
  defp find_intersects([head | tail], set) do
    find_intersects(head, tail, tail, set)
  end
  defp find_intersects(_head, [], next_tail, intersects_set), do:
    find_intersects(next_tail, intersects_set)
  defp find_intersects(head, [head2 | tail], next_tail, intersects_set) do
    set =
      MapSet.intersection(head, head2)
      |> MapSet.union(intersects_set)
    find_intersects(head, tail, next_tail, set)
  end

  def find_unique_claim(claims) do
    claims
    |> String.split(~r/\n/, trim: true)
    |> Stream.map(&claim_parser/1)
    |> Stream.map(&claim_set_with_ids/1)
    |> Enum.to_list()
    |> search()
  end

  defp search(list), do: search(list, list)
  defp search([head | tail], list) do
    IO.inspect(head, label: "head")
    IO.inspect(Enum.map(list, &(&1["id"])), label: "keys")
    if(is_unique?(head, list)) do
      head["id"]
    else
      search(tail, list)
    end
  end
  defp search([], _list), do: raise "You should not have reached this error."

  defp is_unique?(_head, []), do: true
  defp is_unique?(head, [head | tail ]), do: is_unique?(head, tail)
  defp is_unique?(head, [head2 | tail ]) do
    if MapSet.disjoint?(head["coords"], head2["coords"]) do
        is_unique?(head, tail)
    else
      false
    end
  end

  def parse_claim(claim) when is_binary(claim) do
    claim
    |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Retrieves all claimed inches.

  ## Examples
  iex> claimed = Day3.claimed_inches([
  ...>  "#1 @ 1,3: 4x4",
  ...>  "#2 @ 3,1: 4x4",
  ...>  "#3 @ 5,5: 2x2",
  ...> ])
  iex> claimed[{4,2}]
  [2]
  iex> claimed[{4,4}]
  [2, 1]
  """
  def claimed_inches(claims) do
    Enum.reduce(claims, %{}, fn claim, acc ->
      [id, left, top, width, height] = parse_claim(claim)

      Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  def overlapped_inches(claims) do
    for {coordinate, [_, _ | _]} <- claimed_inches(claims), do: coordinate
  end

  @doc """
  ## Find non_overlapping_claim
  iex> claimed = Day3.non_overlapping_claim([
  ...>  "#1 @ 1,3: 4x4",
  ...>  "#2 @ 3,1: 4x4",
  ...>  "#3 @ 5,5: 2x2",
  ...> ])
  3
  """
  def non_overlapping_claim(claims) do
    parsed_claims = Enum.map(claims, &parse_claim/1)

    overlapped_claims =
      Enum.reduce(parsed_claims, %{}, fn [id, left, top, width, height], acc ->
        Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
          Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
            Map.update(acc, {x, y}, [id], &[id | &1])
          end)
        end)
      end)

      [id, _, _, _, _] =
        Enum.find(parsed_claims, fn [id, left, top, width, height] ->
          Enum.all?((left + 1)..(left + width), fn x ->
            Enum.all?((top + 1)..(top + height), fn y ->
              Map.get(overlapped_claims, {x, y}) == [id]
            end)
          end)
        end)
      id
  end
end
