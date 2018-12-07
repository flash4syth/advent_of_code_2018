defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """

  def sleepiest_guard_minute_product(schedule) do
    schedule
    |> String.split("\n", trim: true)
    |> Enum.sort()
    |> build_accumulator()
  end

  def build_accumulator(sorted_schedule) do
    initial_acc = %{
      sleepiest_guard: {_id = nil, _total_sleep_minutes = 0, _sleepiest_minute = nil},
      curr_guard: nil,
      curr_minute: nil,
      guard_data: %{},
    }
    # guard_data: %{
    #   id => %{
    #     total_minutes_asleep => 0,
    #     sleeping_minutes => %{[minute] => count}
    #   }
    # }

    Enum.reduce(sorted_schedule, initial_acc, fn line, acc ->
        line
        |> parse_schedule_line()
        |> state_transition(acc)
    end)
  end

  defp parse_schedule_line(line) do
    String.split(line, ["[", "-", " ", ":", "]"], trim: true)
  end

  # Possible inputs
  # ["1518", "11", "01", "00", "05", "falls", "asleep"]
  # ["1518", "11", "01", "00", "25", "wakes", "up"]

  # New shift event
  defp state_transition([_year, _month, _day, _hour, minute, "Guard", id | _], acc) do
    # IO.puts "Change of guard"
    initial_guard_data = %{
      total_minutes_asleep: 0,
      sleeping_minutes: %{}
    }

    update_in(acc.guard_data, fn data ->
      case Map.has_key?(data, id) do
        true -> data
        false -> Map.put(data, id, initial_guard_data)
      end
    end)
    |> Map.put(:curr_guard, id)
  end
  # Wake up event
  defp state_transition([_year, _month, _day, _hour, minute, "wakes" | _], acc) do
    # IO.puts "Wake up"
    acc
  end
  # Fall asleep event
  defp state_transition([_year, _month, _day, _hour, minute, "falls" | _], acc) do
    # IO.puts "Go to sleep"
    update_in(acc,
      [:guard_data, acc.curr_guard, :sleeping_minutes],
      fn sleeping_minutes ->
        sleeping_minutes
        |> Map.update([minute], 1, &(&1 + 1))
    end)
    |> Map.put(:machine_state, :asleep)
    |> Map.put(:curr_minute, minute)
  end
end
