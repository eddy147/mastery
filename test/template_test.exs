defmodule Test.Mastery.Core.TemplateTest do
  @moduledoc """
  Testing functions from Template
  """
  use ExUnit.Case
  use Test.Support.QuizBuilders

  alias Mastery.Core.Template
  alias Mastery.Core.Response

  doctest Template

  test "building compiles the raw template" do
    fields = template_fields()
    template = Template.new(fields)

    assert is_nil(Keyword.get(fields, :compiled))
    assert not is_nil(template.compiled)
  end

  describe "A right and a wrong response" do
    setup [:right, :wrong]

    test "building responses checkes answers", %{right: right, wrong: wrong} do
      assert right.correct
      refute wrong.correct
    end

    test "a timestamp is added at build time", %{right: response} do
      assert %DateTime{} = response.timestamp
      assert response.timestamp < DateTime.utc_now()
    end
  end

  defp quiz do
    fields = template_fields(generators: %{left: [1], right: [2]})

    build_quiz()
    |> Quiz.add_template(fields)
    |> Quiz.select_question()
  end

  defp response(answer) do
    Response.new(quiz(), 'bla.foo@some.mail.eu', answer)
  end

  defp right(context) do
    {:ok, Map.put(context, :right, response("3"))}
  end

  defp wrong(context) do
    {:ok, Map.put(context, :wrong, response("2"))}
  end
end
