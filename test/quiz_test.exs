defmodule QuizTest do
  use ExUnit.Case
  use QuiBuilders

  alias Mastery.Core.Quiz



  defp eventuall_pick_other_template(quiz, template) do
    Stream.repeatedly(fn ->
      Quiz.select_question(quiz).current_question.template
    end)
    |> Enum.find(fn other -> other != template end)
  end

  defp template(quiz) do
    quiz.current_question.template
  end

  defp answer_question(quiz, answer) do

  end
end
