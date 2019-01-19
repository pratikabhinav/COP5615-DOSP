defmodule Topo do
  def createTopo(topology, pList) do
      pidNeighborMap = Map.new
      case topology do
          "full" ->
              pidNeighborMap =
                  Func.getNeighborForFull(pidNeighborMap, pList, 0)

          "rand2d" ->
              pidNeighborMap =
                  Func.buildTwodTopo(pidNeighborMap, pList, 0, false, length(pList), round(:math.sqrt(length(pList))))

          "imp2d" ->
              pidNeighborMap =
                  Func.buildTwodTopo(pidNeighborMap, pList, 0, true, length(pList), round(:math.sqrt(length(pList))))

          "3d" ->
              pidNeighborMap =
                  Func.buildThreedTopo(pidNeighborMap, pList, 0, length(pList), round(Func.nth_root(3, length(pList))))

          "line" ->
              pidNeighborMap =
                  Func.getNeighborForLine(pidNeighborMap, pList, 0)

          "impline" ->
              pidNeighborMap =
                  Func.getNeighborForImpLine(pidNeighborMap, pList, 0)

          _ ->
            IO.puts "Not implemented. Try another topology from full, line, impline, rand2d, imp2d, 3d."
            exit(:shutdown)
      end
  end
end
