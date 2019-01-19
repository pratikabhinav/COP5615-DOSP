defmodule Func do

  def startGossip(pidNeighborMap, mainID) do
      send mainID, { :beginTimeListener, "" }

      Enum.each pidNeighborMap,  fn {k, v} ->
          send k, { :mainResponse, v }
      end

      keys = Map.keys(pidNeighborMap)
      key = Enum.at(keys, 0)
      send key, { :mainGossip, "Batman is the best" }

  end

  def startPushSum(pidNeighborMap, mainID) do

      send mainID, { :beginTimeListener, "" }

      Enum.each pidNeighborMap,  fn {k, v} ->
          send k, { :mainResponse, v }
      end

      keys = Map.keys(pidNeighborMap)
      key = Enum.at(keys, 0)
      send key, { :mainPushSum, "Superman is a joke" }

  end

  def getPidGossipList(numNodes, pidGossipList, mainListener) do
      if numNodes == 0 do
          pidGossipList
      else
          pidGossipList =
              pidGossipList ++
              [spawn(Gossip, :listen, [mainListener, 0, nil, false, -1])]
          getPidGossipList(numNodes - 1, pidGossipList, mainListener)
      end
  end

  def getPidPushSumList(numNodes, pidGossipList, mainListener, i) do
      if numNodes == 0 do
          pidGossipList
      else
          pidGossipList =
              pidGossipList ++
              [spawn(PushSum, :listen, [mainListener, i, 1, nil, [], false])]
              getPidPushSumList(numNodes - 1, pidGossipList, mainListener, i + 1)
      end
  end


  def getNeighborForFull(map, list, count) do
      if count == length list do
          map
      else
          map = Map.put(map, Enum.at(list, count), (List.delete_at(list, count)))
          getNeighborForFull(map, list, count + 1)
      end
  end

  def getNeighborForLine(map, list, count) do
      if count == length list do
          map
    else
      if count == 0 do
          map = Map.put(map, Enum.at(list, count), [] ++ [Enum.at(list, count + 1)])
          getNeighborForLine(map, list, count + 1)

      else
        if count == ((length list) - 1) do
            map = Map.put(map, Enum.at(list, count), [] ++ [Enum.at(list, count - 1)])
            getNeighborForLine(map, list, count + 1)
        else
            map = Map.put(map, Enum.at(list, count), [] ++ [Enum.at(list, count + 1)] ++ [Enum.at(list, count - 1)])
            getNeighborForLine(map, list, count + 1)
        end

        end
      end
  end

  def getNeighborForImpLine(map, list, count) do
      if count == length list do
          map
      else
        if count == 0 do
          map = Map.put(map, Enum.at(list, count), [] ++ [Enum.at(list, count + 1)] ++ [Enum.random(list)])
          getNeighborForLine(map, list, count + 1)

      else
        if count == ((length list) - 1) do
            map = Map.put(map, Enum.at(list, count), [] ++ [Enum.at(list, count - 1)] ++ [Enum.random(list)])
            getNeighborForLine(map, list, count + 1)
        else
            map = Map.put(map, Enum.at(list, count), [] ++ [Enum.at(list, count + 1)] ++ [Enum.at(list, count - 1)] ++ Enum.random(list))
            getNeighborForLine(map, list, count + 1)
        end

        end
      end
  end

  def buildTwodTopo(pidNeighborMap, pList, index, imperfect, length, size) do

          if(index == length) do
          pidNeighborMap
      else
          val = getNeighborForTwod(index, size, pList, imperfect)
          pidNeighborMap = Map.put(pidNeighborMap,Enum.at(pList,index),val)
          index = index + 1
          buildTwodTopo(pidNeighborMap,pList,index,imperfect,length,size)
      end

  end

  def getNeighborForTwod(index,size, pList, imperfect) do
      row = div(index,size)
      col = rem(index,size)

    rowNeighbor =
            cond do
                col == 0 -> [Enum.at(pList,index+1)]
                col == size - 1 -> [Enum.at(pList,index - 1)]
                true ->  [Enum.at(pList, index - 1), Enum.at(pList, index + 1)]
            end

    colNeighbor =
        cond do
            row == 0 -> [Enum.at(pList,index+size)]
            row == size - 1 -> [Enum.at(pList,index - size)]
            true ->  [Enum.at(pList, index - size), Enum.at(pList, index + size)]
        end

    fullNeighbor =
        if !imperfect do
            rowNeighbor ++ colNeighbor

        else
            fullNeighbor = rowNeighbor ++ colNeighbor
            randNeighbor = getRandNeighbor(index, pList,fullNeighbor)
            fullNeighbor ++ randNeighbor
        end

      fullNeighbor
  end

  def buildThreedTopo(pidNeighborMap,pList,index,length,size) do
          if(index == length) do
          pidNeighborMap
      else
          val = getNeighborThreed(index, size, pList)
          pidNeighborMap = Map.put(pidNeighborMap,Enum.at(pList,index),val)
          index = index + 1
          buildThreedTopo(pidNeighborMap,pList,index,length,size)
      end
  end

  def getNeighborThreed(index,size,pList) do
      grid_size = size * size
      grid_num = div(index, grid_size)
      row = div(index, (size * (grid_num+1)))
      col = rem(index, size)

      rowNeighbor =
          cond do
              col == 0 -> [Enum.at(pList,index+1)]
              col == size - 1 -> [Enum.at(pList,index - 1)]
              true ->  [Enum.at(pList, index - 1), Enum.at(pList, index + 1)]
          end

      colNeighbor =
        cond do
            row == 0 -> [Enum.at(pList,index+size)]
            row == size - 1 -> [Enum.at(pList,index - size)]
            true ->  [Enum.at(pList, index - size), Enum.at(pList, index + size)]
        end

      gridNeighbor =
        cond do
            grid_num == 0 -> [Enum.at(pList, index + grid_size)]
            grid_num == size - 1 -> [Enum.at(pList, index - grid_size)]
            true -> [Enum.at(pList, index + grid_size), Enum.at(pList, index - grid_size)]
        end

      fullNeighbor =
              rowNeighbor ++ colNeighbor ++ gridNeighbor

      fullNeighbor |> Enum.uniq
  end

  def getRandNeighbor(index, list, fullNeighbor) do
      Enum.take_random(list -- ([] ++ fullNeighbor ++ [Enum.at(list, index)]), 1)
  end


# For nth root of any element - taken from https://rosettacode.org/wiki/Nth_root#Elixir
def nth_root(n, x, precision \\ 1.0e-5) do
  f = fn(prev) -> ((n - 1) * prev + x / :math.pow(prev, (n-1))) / n end
  fixed_point(f, x, precision, f.(x))
end

def fixed_point(_, guess, tolerance, next) when abs(guess - next) < tolerance, do: next
def fixed_point(f, _, tolerance, next), do: fixed_point(f, next, tolerance, f.(next))
end
