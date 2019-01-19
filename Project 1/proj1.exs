defmodule Server do

  def start(n,k, actors, work) do
    spawn_link(Server, :solve, [n, k, actors, work])
  end

  def solve(n, k, actors, work) do
    Process.flag(:trap_exit, true)
    IO.puts "n is : #{n}"
    IO.puts "k is : #{k}"
    IO.puts "number of actors are : #{actors}"
    IO.puts "workunit for each actor is : #{work}"
    IO.puts "You can also set the number of actors and the workunit for each actor. Read comments on line 97, 98 & 107. "
    IO.puts " "
    pid = self()
    clients = Enum.map(1..actors, fn _ -> Client.create(pid) end)
    loop(clients, n, k, work)
  end

  def loop(clients, n, k, work) when n > 0 do
    receive do
      {:ready, cid} ->
        #IO.puts Process.alive?(cid)
        send cid, {:process, n, k, work, self()}
        loop(clients, n-work, k, work)

      {:EXIT, _, reason} ->
        IO.puts("Exit reason Server: #{reason}")
    end
  end

  def loop(_, _, _, _) do
    nil
  end

end

defmodule Client do

  def create(server) do
    spawn_link(Client, :init, [server])
  end

  def init(server) do
    send server, {:ready, self()}
    loop()
  end

  def loop() do
    receive do
      {:process, x, k, work, server} ->
        Test.f(x, k, work)
        send server, {:ready, self()}
        loop()

      {:EXIT, _, reason} -> IO.puts("Exit reason Client: #{reason}")
    end

  end
end

defmodule Test do

  def f(n, k, work) do
    s = max(1, n-work+1)
    check(s, n, k)
  end

  def sumsq(first, first) do
      first * first
  end

  def sumsq(first, last) do
    first * first + sumsq(first + 1, last);
  end

  def check(s, n, k) when s <= n do
    sq = sumsq(s, s + k - 1);
    #IO.puts "Sum of sq : #{sq}"
    x = :math.sqrt(sq)
    #IO.puts "Sq : #{x}"
    #IO.puts "Is Integer : #{is_integer(x)}"
    if (trunc(x) == x) do
      IO.puts "#{s}"
    end
    check(s + 1, n, k);
  end

  def check(_s, _n, _k) do
    nil
  end

end

Process.flag(:trap_exit, true)

#To run for varying actors and work, comment the following lines.
#The default number of actors are 50 and the workunit is also 50

[arg1, arg2] = System.argv
n = arg1 |> String.to_integer
k = arg2 |> String.to_integer
Server.start(n, k, 25, 50) #hard-coded values for number of actors and workunit



#to supply number of actors, uncomment the following lines
#[arg1, arg2, arg3, arg4] = System.argv
#n = arg1 |> String.to_integer
#k = arg2 |> String.to_integer
#actors = arg3 |> String.to_integer
#workunit = arg4 |> String.to_integer
#Server.start(n,k, actors, workunit)


receive do
 {:EXIT, _, reason} ->
    IO.puts("Program exit reason: #{reason}")
end
