defmodule Day1 do
  def final_frequency(file_content) do
    file_content
    |> String.split(~r/\n/, trim: true)
    |> Stream.cycle()
    |> Stream.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Enum.reduce_while({0, MapSet.new([0])}, fn integer, {total, seen} ->
      new_freq = integer + total
      case MapSet.member?(seen, new_freq) do
        true ->
          {:halt, {new_freq, MapSet.size(seen)}}
        false ->
          {:cont, {new_freq, MapSet.put(seen, new_freq)}}
      end
    end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day1Test do
      use ExUnit.Case

      import Day1

      test "sum of input" do
        StringIO.open("""
        +1
        +1
        +1
        """)
        assert final_frequency(IO.stream(io, :line)) == 3
      end

      test "first repeated number" do
        [1,2,3]
      end
    end

  [input_file] ->
    input_file
    |> File.read!()
    |> Day1.final_frequency()
    |> IO.inspect()

  _ ->
    IO.puts :stderr, "we expected --test or an input file"
    System.halt(1)
end
