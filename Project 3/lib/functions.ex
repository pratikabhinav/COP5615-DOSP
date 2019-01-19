defmodule Functions do

  def getNodeFromNode(state, hValue) do
    nodeid = state[:nodeid]
    setOne = state[:minimumSet]
    setTwo = state[:maximumSet]

    minimum =
      if setOne != [] do
        [a | b] = setOne
        {m11, result} = findMinimum(b, a, [])
        m11
      else
        nodeid
      end

    maximum =
      if setTwo != [] do
        [a | b] = setTwo
        {m12, result} = findMaximum(b,a,[])
        m12
      else
        nodeid
      end

    if minimum <= hValue &&  hValue <= maximum do
      true
    else
      false
    end
  end


  def getNodeFromTable(state, hash) do
    nodeid = state[:nodeid]

  {n, next, rem} = Functions.preTuple(nodeid, hash, 0, 32)

    j = Functions.hexToInt(next, nodeid, hash)
    route = state[:route]
    if route && route[n] && route[n][j] do
      route[n][j]
    else
      nil
    end
  end

  def upFingerTable(state, n, next, initiatorHash, initiatorPid) do
    route = state[:route]
    sub = route[n]
    if !sub do
      sub = %{}
    end
    if !sub[next] do
      sub = Map.put(sub, next, {initiatorHash, initiatorPid})
    end
    route = Map.put(route, n, sub)

    state = Map.put(state, :route, route)
    state
  end

  def hexToInt(ch, s1, s2) do
    case ch do
      "a" -> 10
      "b" -> 11
      "c" -> 12
      "d" -> 13
      "e" -> 14
      "f" -> 15
      _ -> {n, _} = ch |> Integer.parse
          n
    end
  end

  def preTuple(s1, s2, n, rem) do
    if rem == 0 do
      {n,"",""}
    else
      s11 = String.slice(s1, 0,1)
      s12 = String.slice(s2, 0,1)
      if s11 == s12 do
        preTuple(String.slice(s1, 1..-1), String.slice(s2, 1..-1), n+1, rem-1)
      else
        next = String.slice(s2, 0,1)
        {n,next, String.slice(s2, 1..-1)}
      end
    end
  end

  def findMinimum(list, minimum, result) do
    if list == [] do
      {minimum, result}
    else
      [a | b] = list
      {a1 , b1} = minimum
      {c1 , d1} = a
      if a1 > c1 do
        result = [minimum | result]
        minimum = a
      else
        result = [a | result]
      end
      findMinimum(b, minimum, result)
    end
  end

  def findMaximum(list, maximum, result) do
    if list == [] do
      {maximum, result}
    else
      [a | b] = list
      {a1 , b1} = maximum
      {c1 , d1} = a
      if a1 < c1 do
        result = [maximum | result]
        maximum = a
      else
        result = [a | result]
      end
      findMaximum(b, maximum, result)
    end
  end
end

defmodule Update do

  def fetchAndUpdateState(state, table, setOne, setTwo, cHash, cPid) do
    state
      |> getEndNodes(setOne, setTwo)
      |> getEachRoute(table)
      |> update(cHash, cPid)
  end

  def getEndNodes(state, setOne, setTwo) do
    state |> getEachNode(setOne) |> getEachNode(setTwo)
  end

  def getEachNode(state, setOne) do
    if setOne == [] do
      state
    else
      [q | setOne] = setOne
      {a,b} = q
      state = update(state, a, b)
      getEachNode(state, setOne)
    end
  end

  def getEachRoute(state, table) do
    state = mapIterator(state, 0,0, 32, 16, table)
  end

  def mapIterator(state, i, j, m, n, table) do
    if i < m do
      if table[i] do
        if j < n do
          if table[i][j] do
            {a,b} = table[i][j]
            state = update(state, a, b)
          end
          j = j+1
        else
          j = 0
          i = i+1
        end
      else
        i = i+1
      end
      mapIterator(state, i, j, m,n,table)
    else
      state
    end
  end

  def update(state, initiatorHash, initiatorPid) do
    nodeid = state[:nodeid]
    if nodeid != initiatorHash do
      setOne = state[:minimumSet]
      setTwo = state[:maximumSet]
      re = nil
      if initiatorHash < nodeid do
        if length(setOne) < 1 do
          setOne = [{initiatorHash, initiatorPid} | setOne]
        else
          {re, setOne} = Functions.findMinimum(setOne, {initiatorHash, initiatorPid}, [])
        end
      else
        if length(setTwo) < 1 do
          setTwo = [{initiatorHash, initiatorPid} | setTwo]
        else
          {re, setTwo} = Functions.findMaximum(setTwo, {initiatorHash, initiatorPid}, [])
        end
      end
      state = Map.put(state, :minimumSet, setOne)
      state = Map.put(state, :maximumSet, setTwo)
      if re do
        {n, next, _} = Functions.preTuple(nodeid,initiatorHash, 0, 32)
        next = Functions.hexToInt(next, nodeid, initiatorHash)
        state = Functions.upFingerTable(state, n, next, initiatorHash, initiatorPid)
      end
      state
    else
      state
    end
  end

end
