defmodule Reversi.Board do

  defstruct map: %{}

  @cols ~w[a b c d e f g h]
  @rows ~w[1 2 3 4 5 6 7 8]

  @cols_map @cols |> Enum.with_index |> Enum.into %{}
  @rows_map @rows |> Enum.with_index |> Enum.into %{}

  @directions ~w[n e s w ne se sw nw]a

  @type t :: %__MODULE__{}
  @type coords :: {String.t, String.t}

  @spec new :: t
  def new do
    map = for col <- @cols, row <- @rows, into: %{} do
      {coords(col, row), :empty}
    end

    %__MODULE__{map: map}
    |> put(coords("d", "4"), :white)
    |> put(coords("e", "5"), :white)
    |> put(coords("d", "5"), :black)
    |> put(coords("e", "4"), :black)
  end

  @spec coords(String.t, String.t) :: coords
  def coords(col, row) when col in @cols and row in @rows do
    {Map.get(@cols_map, col), Map.get(@rows_map, row)}
  end

  @spec put(t, coords, :black | :white) :: t | {:error, String.t}
  def put(board, coords, color) when color in [:black, :white] do
    case get(board, coords) do
      :empty -> do_put(board, coords, color)
      _ -> {:error, "you can't put there"}
    end
  end

  @spec do_put(t, coords, atom) :: t
  defp do_put(board, coords, color) do
    map_after_putting = Map.put(board.map, coords, color)

    map_after_flipping = Enum.reduce @directions, map_after_putting, fn direction, acc_map ->
      coords_list = coords |> coords_list(direction)
      colors_list = coords_list |> Enum.map(& Map.get(acc_map, &1))
      flip_or_not = colors_list |> judge_flip

      [coords_list, colors_list, flip_or_not]
      |> List.zip
      |> Enum.reduce acc_map, fn
        {coords,  :black, true},  map -> Map.put(map, coords, :white)
        {coords,  :white, true},  map -> Map.put(map, coords, :black)
        {_coords, _color, false}, map -> map
      end
    end

    %__MODULE__{map: map_after_flipping}
  end

  @spec judge_flip([:black | :white | :empty, ...]) :: [boolean]
  defp judge_flip(disks_line = [head | _]) when head in [:black, :white] do
    do_judge_flip(disks_line)
  end

  @spec do_judge_flip([:black | :white | :empty, ...]) :: [boolean]
  defp do_judge_flip([a, b, b, b, b, b, b, a]) when not b in [a, :empty] do
    [false, true, true, true, true, true, true, false]
  end

  defp do_judge_flip([a, b, b, b, b, b, a | rest]) when not b in [a, :empty] do
    [false, true, true, true, true, true, false | falses(rest)]
  end

  defp do_judge_flip([a, b, b, b, b, a | rest]) when not b in [a, :empty] do
    [false, true, true, true, true, false | falses(rest)]
  end

  defp do_judge_flip([a, b, b, b, a | rest]) when not b in [a, :empty] do
    [false, true, true, true, false | falses(rest)]
  end

  defp do_judge_flip([a, b, b, a | rest]) when not b in [a, :empty] do
    [false, true, true, false | falses(rest)]
  end

  defp do_judge_flip([a, b, a | rest]) when not b in [a, :empty] do
    [false, true, false | falses(rest)]
  end

  defp do_judge_flip(disks) do
    falses(disks)
  end

  defp falses(list) when is_list(list) do
    length(list) |> falses
  end

  defp falses(length) do
    List.duplicate(false, length)
  end

  def get(board, coords) do
    Map.get(board.map, coords)
  end

  def empty?(board, coords) do
    get(board, coords) == :empty
  end

  def to_string(board) do
    header = "   " <> Enum.join(@cols, " ")
    Enum.reduce @rows, header, fn row, lines ->
      line = Enum.reduce @cols, "", fn col, acc ->
        case get(board, coords(col, row)) do
          :black -> acc <> "×"
          :white -> acc <> "○"
          :empty -> acc <> "  "
        end
      end
      "#{lines}\n#{row} #{line}"
    end
  end

  [
    n:  { 0, -1},
    e:  { 1,  0},
    s:  { 0,  1},
    w:  {-1,  0},
    ne: { 1, -1},
    se: { 1,  1},
    sw: {-1,  1},
    nw: {-1, -1}
  ]
  |> Enum.map fn {direction, {col_diff, row_diff}} ->
    defp coords_list(start_coords, unquote(direction)) do
      do_coords_list(start_coords, unquote(col_diff), unquote(row_diff), [])
    end
  end

  defp do_coords_list(coords = {col, row}, col_diff, row_diff, acc) do
    next_coords = {col+col_diff, row+row_diff}
    if out_of_board?(next_coords) do
      Enum.reverse [coords | acc]
    else
      do_coords_list(next_coords, col_diff, row_diff, [coords | acc])
    end
  end

  defp out_of_board?({-1, _}), do: true
  defp out_of_board?({ 8, _}), do: true
  defp out_of_board?({_, -1}), do: true
  defp out_of_board?({_,  8}), do: true
  defp out_of_board?({_,  _}), do: false
end
