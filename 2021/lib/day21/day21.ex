defmodule Day21 do
  alias Day21.Deterministic
  alias Day21.Quantum

  def main(input) do
    {p1_pos, p2_pos} = parse(input)

    Deterministic.play({p1_pos, p2_pos})
    |> IO.inspect(label: "with deterministic die")

    Quantum.play({p1_pos, p2_pos})
    |> IO.inspect(label: "with quantum die")
  end

  def parse(input) do
    [p1, p2] = String.split(input, "\n", trim: true)
    "Player 1 starting position: " <> p1_pos = p1
    "Player 2 starting position: " <> p2_pos = p2
    {String.to_integer(p1_pos), String.to_integer(p2_pos)}
  end
end


defmodule Day21.Quantum do

  def play({p1_pos, p2_pos}) do
    :ets.new(:cache, [:set, :public, :named_table])
    {nb_win, _} = play(p1_pos, p2_pos, 0, 0, 1)
    nb_win
  end

  def play(p1_pos, p2_pos, score_p1, score_p2, turn) do
    key = "#{p1_pos} - #{p2_pos} - #{score_p1} - #{score_p2} - #{turn}"
    result_from_cache = get_value_from_cache(key)

    if result_from_cache do
      result_from_cache
    else
      result = compute_round(p1_pos, p2_pos, score_p1, score_p2, turn)
      :ets.insert(:cache, {key, result})
      result
    end
  end

  def compute_round(p1_pos, p2_pos, score_p1, score_p2, turn) do
    dices = for x <- 1..3, y <- 1..3, z <- 1..3, do: x + y + z
    result = if turn == 1 do
      Enum.map(dices, &round(p1_pos, score_p1, &1))
    else
      Enum.map(dices, &round(p2_pos, score_p2, &1))
    end

    Enum.reduce(result, {0, 0}, fn {pos, score}, {nb_win, nb_lost} ->
      if score >= 21 do
        # if p1 wins, we inc the wins, if p2 wins, we inc the losses
        if turn == 1, do: {nb_win + 1, nb_lost}, else: {nb_win, nb_lost + 1}
      else
        {has_won_next_turn, has_lost_next_turn} = if turn == 1 do
          play(pos, p2_pos, score, score_p2, 2)
        else
          play(p1_pos, pos, score_p1, score, 1)
        end
        {has_won_next_turn + nb_win, has_lost_next_turn + nb_lost}
      end
    end)
  end

  def get_value_from_cache(key) do
    result_from_cache = :ets.lookup(:cache, key)

    if Enum.count(result_from_cache) > 0 do
      [result] = result_from_cache
      {^key, result} = result
      result
    else
      nil
    end
  end

  def round(pos_player, score, dice) do
    new_pos = compute_new_pos(pos_player, dice)
    new_score = score + new_pos
    {new_pos, new_score}
  end

  def compute_new_pos(pos, rolled_number) do
    Stream.cycle(1..10)
    |> Enum.take(pos + rolled_number)
    |> Enum.reverse()
    |> Enum.at(0)
  end
end


defmodule Day21.Deterministic do

  def play({p1_pos, p2_pos}) do
    Stream.iterate(3, &(&1 + 3))
    |> Enum.reduce_while({p1_pos, p2_pos, 0, 0, 1}, fn nb_roll, {p1_pos, p2_pos, p1_score, p2_score, dice} ->
      {p1_pos, p1_score, dice} = round(p1_pos, p1_score, dice)
      if p1_score >= 1000 do
        {:halt, nb_roll * p2_score}
      else
        # inverse who is p1 and who is p2
        {:cont, {p2_pos, p1_pos, p2_score, p1_score, dice}}
      end
    end)
  end

  def round(pos_player, score, dice) do
    {dice, number_1} = roll_dice(dice)
    {dice, number_2} = roll_dice(dice)
    {dice, number_3} = roll_dice(dice)
    new_pos = compute_new_pos(pos_player, number_1 + number_2 + number_3)
    {new_pos, score + new_pos, dice}
  end

  def compute_new_pos(pos, rolled_number) do
    Stream.cycle(1..10)
    |> Enum.take(pos + rolled_number)
    |> Enum.reverse()
    |> Enum.at(0)
  end

  def roll_dice(dice) do
    {rem(dice + 1, 100), dice}
  end
end
