defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  @unsorted_hours  """
  [1518-11-01 00:05] falls asleep
  [1518-11-01 00:25] wakes up
  [1518-11-01 00:00] Guard #10 begins shift
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-01 00:30] falls asleep
  [1518-11-01 00:55] wakes up
  [1518-11-03 00:05] Guard #10 begins shift
  [1518-11-02 00:40] falls asleep
  [1518-11-04 00:02] Guard #99 begins shift
  [1518-11-02 00:50] wakes up
  [1518-11-03 00:24] falls asleep
  [1518-11-03 00:29] wakes up
  [1518-11-05 00:03] Guard #99 begins shift
  [1518-11-04 00:36] falls asleep
  [1518-11-04 00:46] wakes up
  [1518-11-05 00:55] wakes up
  [1518-11-05 00:45] falls asleep
  """

  test "find sleepiest leader then the product of id x sleepiest minute" do
    assert @unsorted_hours |> Day4.sleepiest_guard_minute_product() == 240
  end

  test "find sleepiest minute leader of all and product of id X minute" do
    assert @unsorted_hours |> Day4.sleepiest_minute_leader_product() == 4455
  end

end
