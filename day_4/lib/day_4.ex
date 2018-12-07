defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """


  def sleep_data_builder(schedule) do
    schedule
    |> String.split("\n", trim: true)
    |> Enum.sort()
    |> build_accumulator()
  end

  def sleepiest_guard_minute_product(schedule) do
    schedule
    |> sleep_data_builder()
    |> (fn acc ->
          {id, _total, min} = acc.sleep_leader
          id * min
        end).()
  end

  def sleepiest_minute_leader_product(schedule) do
    acc =
      schedule
      |> sleep_data_builder()

    Enum.reduce(acc.guard_data,
                {_id = nil, _min = nil, _total = 0},
                fn {guard_id, data}, {_id, _min, total} = acc ->

      with true <- Map.size(data.sleeping_minutes) > 0,
        {[id], max} <- Enum.max_by(data.sleeping_minutes, fn {_, count} -> count end),
        true <- max > total do
          {guard_id, id, max}
        else _error ->
          acc
        end
    end)
    |> (fn {id, min, _total} -> id * min end).()
  end

  def build_accumulator(sorted_schedule) do
    initial_acc = %{
      sleep_leader: {_id = nil, _total_sleep_minutes = 0, _sleepiest_minute = nil},
      curr_guard: nil,
      start_sleep_minute: nil,
      guard_data: %{},
    }
    # guard_data: %{
    #   id => %{
    #     sleeping_minutes => %{minute => count}
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
  defp state_transition([_year, _month, _day, _hour, _minute, "Guard", id | _], acc) do
    # IO.puts "Change of guard"
    initial_guard_data = %{
      sleeping_minutes: %{}
    }
    [id] = String.split(id, "#", trim: true) |> Enum.map(&String.to_integer/1)

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
    update_in(acc,
      [:guard_data, acc.curr_guard, :sleeping_minutes],
      fn sleeping_minutes ->
        Enum.reduce(
              acc.start_sleep_minute..String.to_integer(minute)-1,
              sleeping_minutes,
              fn(min, acc) ->
                Map.update(acc, [min], 1, &(&1 + 1))
        end)
      end)
    |> update_sleep_leader()
  end
  # Fall asleep event
  defp state_transition([_year, _month, _day, _hour, minute, "falls" | _], acc) do
    # IO.puts "Go to sleep"
    acc |> Map.put(:start_sleep_minute, String.to_integer(minute))
  end

  defp update_sleep_leader(acc) do
    {_, leader_total_sleep, _} = acc.sleep_leader

    guard_total_sleep = calculate_sleep(acc)

    if guard_total_sleep > leader_total_sleep do
      {[min], _count } = sleepiest_minute(acc)
      %{acc | sleep_leader: {acc.curr_guard, guard_total_sleep, min}}
    else
      acc
    end
  end

  defp calculate_sleep(acc) do
    acc.guard_data[acc.curr_guard].sleeping_minutes
    |> Map.values
    |> Enum.sum()
  end

  defp sleepiest_minute(acc) do
    Enum.max_by(acc.guard_data[acc.curr_guard].sleeping_minutes, fn {_, value} ->
      value
    end)
  end
end
