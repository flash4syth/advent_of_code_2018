defmodule Day3Test do
  use ExUnit.Case

  doctest Day3
  
  @claims """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """
  test "number of overlapping claims" do
    assert Day3.claim_overlap_count(@claims) == 4
  end

  test "finds single exclusive claim" do
    assert Day3.find_unique_claim(@claims) == "3"
  end
end
