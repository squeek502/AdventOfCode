local get = function(path)
  local f = io.open(path, "r")
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end
local input = get('input.txt')

local potential = {}

for _, line in ipairs(input) do
  local a, dir, happiness, b = line:match("^(%w+) would (%w+) (%d+) .- (%w+)%.$")
  happiness = tonumber(happiness)
  if dir == "lose" then
    happiness = -happiness
  end
  if not potential[a] then potential[a] = {} end
  potential[a][b] = happiness
end

local function copy(tbl)
  local cp = {}
  for k,v in pairs(tbl) do cp[k] = v end
  return cp
end

local function pairsCount(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local function getAvailable()
  local available = {}
  for k,v in pairs(potential) do
    available[k] = true
  end
  return available
end

local function getPossibleArrangements(from, arrangement, available)
  if from == nil then from = next(potential) end
  if arrangement == nil then arrangement = {} end
  if available == nil then available = getAvailable() end
  available = copy(available)
  arrangement = copy(arrangement)
  available[from] = nil
  table.insert(arrangement, from)

  local arrangements = {}
  if pairsCount(available) == 0 then
    return {arrangement}
  else
    for person in pairs(available) do
      local future = getPossibleArrangements(person, arrangement, available)
      for _, arr in ipairs(future) do
        table.insert(arrangements, arr)
      end
    end
  end
  return arrangements
end

local function calcHappiness(arrangement)
  local happiness = 0
  for i=1,#arrangement do
    local cur = arrangement[i]
    local prev = arrangement[modIndex(i-1, #arrangement)]
    local nex = arrangement[modIndex(i+1, #arrangement)]
    happiness = happiness + potential[cur][prev] + potential[cur][nex]
  end
  return happiness
end

local arrangements = getPossibleArrangements()

local happiness = {}
for _, arrangement in ipairs(arrangements) do
  table.insert(happiness, calcHappiness(arrangement))
end

local maxHappiness = math.max(unpack(happiness))
print(maxHappiness)
