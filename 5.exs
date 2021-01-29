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
    |> String.graphemes
    #|> IO.inspect
    |> Enum.reduce({0, 7}, fn char, {low, high} ->
      if char == "L" do
        {low, ((low + high + 1) / 2) - 1}
      else
        {(low + high + 1) / 2, high}
      end
    end)
    #|> IO.inspect
    |> elem(0)
    |> trunc
    #|> IO.inspect
  end

  # could de-dup w/ row()
  defp column(line) do
    String.slice(line, 0, 7)
    |> String.graphemes
    #|> IO.inspect
    |> Enum.reduce({0, 127}, fn char, {low, high} ->
      if char == "F" do
        {low, ((low + high + 1) / 2) - 1}
      else
        {(low + high + 1) / 2, high}
      end
    end)
    #|> IO.inspect
    |> elem(0)
    |> trunc
    #|> IO.inspect
  end
end

Solver.solve

