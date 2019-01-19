defmodule Gossip do

  def gossip(neighborPidList, messageCount) do
    if neighborPidList != nil && messageCount < 5 do
      randPid = :rand.uniform(length neighborPidList) - 1
      nextGossipPid = Enum.at(neighborPidList, randPid)
      send nextGossipPid, { :response, ""}

      randPid = :rand.uniform(length neighborPidList) - 1
      nextGossipPid = Enum.at(neighborPidList, randPid)
      send nextGossipPid, { :response, ""}
    end
  end

    def listen(mainListener, messageCount, neighborPidList, checkDone, chancePid) do
    receive do
        {:mainResponse, response} ->
            neighborPidList = response

        {:mainGossip, response} ->
            messageCount = messageCount + 1

        {:response, response} ->
            messageCount = messageCount + 1

        after 100 ->
      end

    if messageCount >= 10 && !checkDone do
      checkDone = true
      send mainListener, { :response, "Yo" }
      listen(mainListener, messageCount, neighborPidList, checkDone, chancePid)
  else
      if checkDone do
          #Post 1 second to random neighbor
          :timer.sleep(1000)
          randPid = :rand.uniform(length neighborPidList) - 1
          nextGossipPid = Enum.at(neighborPidList, randPid)
          send nextGossipPid, { :response, ""}
      end
      if messageCount > 0 do
          gossip(neighborPidList, messageCount)
      end
      listen(mainListener, messageCount, neighborPidList, checkDone, chancePid)
    end
    end

end
