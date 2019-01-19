defmodule ChordNode do

  def create(index, mpid, firstPid) do
    args = [index, mpid, firstPid]
    Task.start_link(__MODULE__, :loop, args)
  end

  def loop(i, mpid, firstPid) do
    hValue = Hash.getHash(to_string(i))
    i = to_string(i)
    state = %{ :nodeid => hValue, :nodenum => i, :route => %{}, :pids => [], :sum => -1, :curr => %{i=>self()}, :mpid => mpid, :minimumSet => [], :maximumSet => [] }
    if firstPid do
      send firstPid, { :join, self(), hValue}
    else
      send mpid, {:ready}
    end
    loop(state)
  end

  def loop(state) do
    receive do
      {:join, newNodeId, hValue} ->
          state = joiner(newNodeId, hValue, state, 1)
          loop(state)

      {:joinMany, newNodeId, hValue, number} ->
          state = joiner(newNodeId, hValue, state, number)
          loop(state)

      {:joinTable, initiatorPid, initiatorHash, number, table, m1, m2} ->
          state = Update.fetchAndUpdateState(state, table, m1, m2, initiatorHash, initiatorPid)
          pids = state[:pids]
          pids = [initiatorPid | pids]
          state = Map.put(state, :pids, pids)

          if length(pids) == state[:sum] do
            routeToIds(pids, state[:nodeid], state)
            routeToIds(state[:m1], state[:nodeid], state)
            routeToIds(state[:m2], state[:nodeid], state)
            send state[:mpid], {:ready}
          end

          loop(state)

      {:fingerTable, initiatorPid, initiatorHash, table, m1, m2} ->
          state = Update.fetchAndUpdateState(state, table, m1, m2, initiatorHash, initiatorPid)
          loop(state)

      {:endNodes, initiatorHash, initiatorPid, number, minimumSet, maximumSet} ->
          state = put_in state[:sum], number
          pids = state[:pids]
          m1 = []
          m2 = []
          m1 = pidsCollector(minimumSet, m1)
          m2 = pidsCollector(maximumSet, m2)
          state = Map.put(state, :m1, m1)
          state = Map.put(state, :m2, m2)

          if length(pids) == state[:sum] do
            routeToIds(pids, state[:nodeid], state)
            routeToIds(state[:m1], state[:nodeid], state)
            routeToIds(state[:m2], state[:nodeid], state)
            send state[:mpid], {:ready}
          end

          loop(state)

      {:route, key, number} ->
          val = route(state, key, number)

          if val do
            send state[:mpid], {:hops, number}
          end

          loop(state)

      {:debugOutput} -> nodeid =
          state[:nodeid]
          IO.puts "node => " <> state[:nodenum] <> " " <> nodeid <> " " <> inspect(state)
          loop(state)
    end
  end

  def pidsCollector(l, pids) do
    if l == [] do
      pids
    else
      [a | l] = l
      {b, c} = a
      pids = [ c | pids ]
      pidsCollector(l, pids)
    end
  end

  def joiner(newId, hValue, state, number) do
    nodeid = state[:nodeid]
    send newId, {:joinTable, self(), nodeid, number, state[:route], state[:minimumSet], state[:maximumSet]}

    if Functions.getNodeFromNode(state, hValue) do
      send newId, {:endNodes, nodeid, self(), number, state[:minimumSet], state[:maximumSet]}
    else
      rNode = Functions.getNodeFromTable(state, hValue)
      if rNode do
        {hash, rNodePid} = rNode
        send rNodePid, {:joinMany, newId, hValue, number+1}
      else
        send newId, {:endNodes, nodeid, self(), number, state[:minimumSet], state[:maximumSet]}
      end
    end
    state
  end

  def routeToIds(pids, nodeid, state) do
    if pids != [] do
      [pid | pids] = pids
      send pid, {:fingerTable, self(), nodeid, state[:route], state[:minimumSet], state[:maximumSet]}
      routeToIds(pids, nodeid, state)
    end
  end

  def route(state, key, number) do
    if state[:nodeid] != key do
      if Functions.getNodeFromNode(state, key) do
        number
      else
        route = state[:route]
        rNode = Functions.getNodeFromTable(state, key)
        if rNode do
          {hash, rNodePid} = rNode
          send rNodePid, {:route, key, number+1}
          nil
        else
          number+1

        end
      end
    else
      number
    end
  end

end
