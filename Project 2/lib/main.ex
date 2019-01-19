defmodule Main do

  def main(args) do

    numNodes = String.to_integer(Enum.at(args, 0))

    if numNodes <= 1 do
        IO.puts "Invalid. Number of nodes should be greater than 1"
        exit(:shutdown)
    end

    topology = Enum.at(args, 1)
    algo = Enum.at(args, 2)

    if topology == "rand2d" || topology == "imp2d" do
        numNodes = :math.pow(round(:math.sqrt(numNodes)),2) |> round
    end

    if topology == "3d" do
        numNodes = :math.pow(round(Func.nth_root(3, numNodes)),3) |> round
    end

    mainID = spawn(Main, :listen, [0, numNodes, :os.system_time(:millisecond), self()])

    case algo do
    "gossip" ->
        IO.puts "Number of nodes = #{numNodes}"
        IO.puts "Topology = #{topology}"
        IO.puts "Algorithm = #{algo}"
        pidGossipList = Func.getPidGossipList(numNodes, [], mainID)
        pidNeighborMap = Topo.createTopo(topology, pidGossipList)
        Func.startGossip(pidNeighborMap, mainID)
    "push-sum" ->
        IO.puts "Number of nodes = #{numNodes}"
        IO.puts "Topology = #{topology}"
        IO.puts "Algorithm = #{algo}"
        pidPushSumList = Func.getPidPushSumList(numNodes, [], mainID, 1)
        pidNeighborMap = Topo.createTopo(topology, pidPushSumList)
        Func.startPushSum(pidNeighborMap, mainID)
    end

    receive do
        {:response, _response} ->
    end
  end

  def listen(numCompletedNodes, numNodes, beginTime, pid) do
    receive do
    {:beginTimeListener, _start_response} ->
        beginTime = :os.system_time(:millisecond)

    {:response, _response} ->
        numCompletedNodes = numCompletedNodes + 1
    end


  if numCompletedNodes >= numNodes do
      totalTime = (:os.system_time(:millisecond) - beginTime)
      IO.puts "#{totalTime} milliseconds"
      send pid, {:response, ""}
  else
      listen(numCompletedNodes, numNodes, beginTime, pid)
  end
  end

end
