# functional, so it's different,
# but it's elegant to read once it's written.
# needs a different brain though.

defmodule Solver do
  def solve do
    # unknown seats are missing from unknown num rows
    # at the front and back, so you can't use an
    # expected sum =(

    # an plain array is probably more memory-efficient, but oh well
    ids = File.stream!("5.input")
          |> Stream.map(&id(&1))
          #|> IO.inspect
          |> MapSet.new

    Enum.find(0..955, fn num ->
      !MapSet.member?(ids, num) &&
        MapSet.member?(ids, num - 1) &&
        MapSet.member?(ids, num + 1)
    end)
    |> IO.inspect
  end

  defp id(line) do
    #String.slice(line, 0, 10)
    #|> IO.puts

    (column(line) * 8) + row(line)
  end

  defp row(line) do
    String.slice(line, 7, 3)
    |> magic(7, "L")
    #|> IO.inspect
  end

  # could de-dup w/ row()
  defp column(line) do
    String.slice(line, 0, 7)
    |> magic(127, "F")
    #|> IO.inspect
  end

  # for speed, cache these strings in a map
  defp magic(string, max, lower_char) do
    String.graphemes(string)
    #|> IO.inspect
    |> Enum.reduce({0, max}, fn char, {low, high} ->
      if char == lower_char do
        {low, ((low + high + 1) / 2) - 1}
      else
        {(low + high + 1) / 2, high}
      end
    end)
    #|> IO.inspect
    |> elem(0)
    |> trunc
  end
end

Solver.solve

