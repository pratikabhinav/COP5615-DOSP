defmodule PushSum do

  def pushSum(s, w, neighborPidList) do
    if neighborPidList != nil do
        randPid = :rand.uniform(length neighborPidList) - 1
        nextGossipPid = Enum.at(neighborPidList, randPid)
        send nextGossipPid, { :response, [] ++ [s] ++ [w]}
    end
  end


  def listen(mainListener, s, w, neighborPidList, threeRoundRatio, checkDone) do
  receive do
    {:mainResponse, response} ->
        neighborPidList = response

    {:mainPushSum, response} ->
        s = s / 2
        w = w / 2

        ratio = s / w
        threeRoundRatio = threeRoundRatio ++ [ratio]
        pushSum(s, w, neighborPidList)

    {:response, response} ->
    if !checkDone do
        s = s + Enum.at(response, 0)
        w = w + Enum.at(response, 1)

        s = s / 2
        w = w / 2

        ratio = s / w


        if threeRoundRatio == nil || (length threeRoundRatio) < 4 do
            threeRoundRatio = threeRoundRatio ++ [ratio]
        else
            threeRoundRatio = threeRoundRatio ++ [ratio]
            threeRoundRatio = List.delete_at(threeRoundRatio, 0)
        end

        pushSum(s, w, neighborPidList)
      end

      after 100 ->

    end

       if threeRoundRatio != nil && (length threeRoundRatio) ==  4 do
        if !checkDone do
          if abs((Enum.at(threeRoundRatio, 1) - Enum.at(threeRoundRatio, 0))) <= :math.pow(10, -10) &&
              abs((Enum.at(threeRoundRatio, 2) - Enum.at(threeRoundRatio, 1))) <= :math.pow(10, -10) &&
              abs((Enum.at(threeRoundRatio, 3) - Enum.at(threeRoundRatio, 2))) <= :math.pow(10, -10) do
              checkDone = true
              send mainListener, { :response, "Yo" }
            end
          else
              :timer.sleep(100)
              pushSum(s, w, neighborPidList)
          end
      end

      listen(mainListener, s, w, neighborPidList, threeRoundRatio, checkDone)
  end

end
