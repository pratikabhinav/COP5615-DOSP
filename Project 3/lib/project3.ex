defmodule Project3 do

  def main(args) do
    Process.flag(:trap_exit, true)
    {nodes, _} = Enum.at(args, 0) |> Integer.parse
    {requests, _} = Enum.at(args, 1) |> Integer.parse
    {:ok, pid} = ChordNode.create(1, self(), false)

    :timer.sleep(100)
    list = [pid]

    loop(list, 2, nodes, pid, requests, 0, 0)
  end

  def loop(list, index, node, fpid, requests, count, sum) do
    receive do
      {:request} ->
                Enum.each(list, fn x -> requests(x,0, requests) end)
                loop(list, index, node, fpid, requests, count, sum)
      {:hops, i} ->
                count = count+1
                sum = sum + i
                if count == requests*node do
                  result = sum/count
                  IO.puts "Average hops: #{result}"
                  System.halt(0)
                end
                loop(list, index, node, fpid, requests, count, sum)
      {:ready} ->
                if index <= node do
                  {:ok, pid} = ChordNode.create(index, self(), fpid)
                  list = [pid | list]
                  index = index+1
                else
                  send self(), {:request}
                end

                loop(list,index, node, fpid, requests,count, sum )
    end
  end

  def requests(pid, i, r) do
    if i < r do
      send pid, {:route, Hash.random, 1}
      requests(pid, i+1, r)
    end
  end

end

defmodule Hash do
  def getHash(string) do
    :crypto.hash(:md5, string) |> Base.encode16 |> String.downcase
  end

  def random do
    foo = :rand.uniform(1000)
    getHash(to_string(foo))
  end
end
