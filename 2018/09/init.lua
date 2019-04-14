local input = io.open('input.txt'):read('*l')

local numPlayers, lastMarbleWorth = input:match("(%d+) players; last marble is worth (%d+) points")
numPlayers, lastMarbleWorth = tonumber(numPlayers), tonumber(lastMarbleWorth)

local scores = {}
for i=1,numPlayers do
  scores[i] = 0
end

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local marbles = {0}
local currentMarble = 1
local playerNum = 1
for marble=1, lastMarbleWorth do
  local insertIndex = modIndex(currentMarble+2, #marbles+1)
  if insertIndex == 1 then insertIndex = insertIndex + 1 end
  if marble % 23 == 0 then
    currentMarble = modIndex(currentMarble - 7, #marbles)
    local removed = table.remove(marbles, currentMarble)
    scores[playerNum] = scores[playerNum] + marble + removed
  else
    table.insert(marbles, insertIndex, marble)
    currentMarble = insertIndex
  end
  playerNum = modIndex(playerNum + 1, numPlayers)
end

local function highScore(scores)
  local highScore, player = -math.huge, nil
  for i, score in ipairs(scores) do
    if score > highScore then
      highScore = score
      player = i
    end
  end
  return highScore, player
end

local score = highScore(scores)
print(score)
