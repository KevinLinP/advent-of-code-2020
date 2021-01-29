defmodule Solver do
  def solve do
    File.stream!("5.input")
    |> Stream.map(&score(&1))
    |> Enum.max
    |> IO.inspect
  end

  def score(line) do
    String.slice(line, 0, 10)
    |> IO.puts

    column = column(line)
    row = row(line)

    (column * 8) + row
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

