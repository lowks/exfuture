defmodule ExFuture.HelperTest do
  use ExUnit.Case
  use ExFuture

  test "future block" do
    f = future do
      3 * 3
    end
    assert 9 == value(f)
  end

  test "future block with external parameter" do
    i = 3
    f = future do
      i * 2
    end
    assert value(f) == 6
  end

  test "future block with one argument" do
    f = future(x) do
      x * x
    end
    assert 9 == value(f.(3))
  end

  test "parallel map with future/resolve macro using collection" do
    v = [1, 2, 3]
          |> Enum.map(future(x) do x * 2 end)
          |> Enum.map(resolve)
    assert v == [2, 4, 6]
  end

  test "parallel map with future/resolve macro using range" do
    v = 1..10
          |> Enum.map(future(x) do x * 2 end)
          |> Enum.map(resolve)
    assert v == Enum.map(1..10, fn(x) -> x * 2 end)
  end

  test "parallel map for getting html pages" do
    HTTPotion.start
    HttpServer.start(path: "/test", port: 4000,
                     response: "Custom Response", wait_time: 1000)

    # 10 requests, which each takes 1 second.
    links = List.duplicate("http://localhost:4000/test", 10)

    s = :erlang.now
    htmls = links
              |> Enum.map(future(x) do HTTPotion.get(x).body end)
              |> Enum.map(resolve)

    # It should take more than 1 second, but it should be less than
    # 2 seconds, by the parallel execution.
    time = :timer.now_diff(:erlang.now, s)
    assert(time >= 1_000_000 and time <= 2_000_000)

    assert htmls == List.duplicate("Custom Response", 10)
  end
end
