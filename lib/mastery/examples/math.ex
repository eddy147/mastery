defmodule Mastery.Examples.Math do
  @moduledoc false
  alias Mastery.Core.Quiz

  def template_fields() do
    [
      name: :single_digit_addition,
      category: :addition,
      instructions: "Add the numbers",
      raw: "<%= @left %> + <%= @right %>",
      generators: addition_generators(),
      checker: &addition_checker/2
    ]
  end

  def addition_checker(substitions, answer) do
    left = Keyword.fetch!(substitions, :left)
    right = Keyword.fetch!(substitions, :right)
    to_string(left + right) == String.trim(answer)
  end

  def addition_generators() do
    %{left: Enum.to_list(0..9), right: Enum.to_list(0..9)}
  end

  def quiz_fields() do
    %{mastery: 2, title: :simple_addition}
  end

  def quiz() do
    quiz_fields()
    |> Quiz.new()
    |> Quiz.add_template(template_fields())
  end
end

# iex -S mix
# alias Mastery.Examples.Math
# alias Mastery.Boundary.QuizManager
# GenServer.start_link QuizManager, %{},  name: QuizManager
# QuizManager.build_quiz  title::quiz
# QuizManager.add_template  :quiz, Math.template_fields
# QuizManager.lookup_quiz_by_title  :quiz
