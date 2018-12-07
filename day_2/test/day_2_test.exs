defmodule Day2Test do
  use ExUnit.Case
  import Day2

  @tag :skip
  test "finds checksum of box ids" do
    box_ids = """
      abcdef
      bbbaac
      bbacde
      cccabd
      """

    assert Day2.checksum(box_ids) == 4
  end

  test "get the two lines that differ by one" do
    # data = File.read!("box_ids")
    data = """
    abcd
    afgd
    afed
    """

    assert Day2Part2.find_single_differing_strings(data) == "afd"
  end
end
