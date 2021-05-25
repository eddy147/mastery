defmodule Worker do
  def work(n) do
    if (:rand.uniform(10) == 1) do
      raise "Oops! "
    else
      {:result, :rand.uniform(n * 100)}
    end
  end

  def make_work_safe(dangerous_work, arg) do
    try do
      apply(dangerous_work, [arg])
    rescue
      error ->
        {:error, error, arg}
    end
  end

  def stream_work() do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn i -> make_work_safe(&work/1, i) end)
  end
end

IO.puts "Report partial success:"
Worker.stream_work()
|> Enum.take(20)
|> IO.inspect()

IO.puts "Halt on error wirh context:"
Worker.stream_work()
|> Enum.reduce_while([], fn
  {:error, _error, _context} = error, _results ->
    {:halt, error}
  result, results ->
    {:cont, [result | results]}
end)
|> case do
  {:error, _error, _context} = error ->
    error
  results ->
    Enum.reverse(results)
end
|> IO.inspect
