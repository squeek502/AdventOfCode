local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local _DEBUG = false
local debugprint = function(...) if _DEBUG then print(...) end end

local Pots = {}
Pots.__index = Pots

function Pots.new(initialState)
  local self = setmetatable({}, Pots)
  self.minIndex = 0
  self.maxIndex = 0
  self.state = {}
  for c in initialState:gmatch(".") do
    self.state[self.maxIndex] = c == '#'
    self.maxIndex = self.maxIndex + 1
  end
  self.rules = {}
  return self
end

function Pots:hasPlant(index)
  return self.state[index]
end

function Pots:addRule(pattern, result)
  local patternLookup = {}
  local i = -2
  for c in pattern:gmatch(".") do
    patternLookup[i] = c == '#'
    i = i + 1
  end
  local rule = {
    fn = function(state, pos)
      for i=-2,2 do
        if (state[pos+i] or false) ~= patternLookup[i] then
          return false
        end
      end
      return true
    end,
    result = result == '#'
  }
  table.insert(self.rules, rule)
end

function Pots:sum()
  local sum = 0
  for i=self.minIndex, self.maxIndex do
    if self.state[i] then
      sum = sum + i
    end
  end
  return sum
end

function Pots:runGeneration()
  local newState = {}
  for i=self.minIndex-2, self.maxIndex+2 do
    for _, rule in ipairs(self.rules) do
      if rule.fn(self.state, i) then
        newState[i] = rule.result
        if i < self.minIndex and rule.result then
          self.minIndex = i
        end
        if i > self.maxIndex and rule.result then
          self.maxIndex = i
        end
      end
    end
  end
  -- increment minIndex until we hit a filled pot
  -- so that minIndex doesn't get stuck at an obsolete index
  while not newState[self.minIndex] and self.minIndex < self.maxIndex do
    self.minIndex = self.minIndex + 1
  end
  self.state = newState
end

function Pots:stringState()
  local state = {}
  for i=self.minIndex,self.maxIndex do
    table.insert(state, self.state[i] and '#' or '.')
  end
  return table.concat(state)
end

function Pots:__tostring()
  return string.format("%d:%s:%d", self.minIndex, self:stringState(), self.maxIndex)
end

local initialState = table.remove(input, 1):match("initial state: (.*)")
local pots = Pots.new(initialState)

while input[1] == "" do table.remove(input, 1) end
for _, rule in ipairs(input) do
  local pattern, result = rule:match("([^ ]+) => (.)")
  pots:addRule(pattern, result)
end

-- Part 1
debugprint('0:', pots)
for i=1,20 do
  pots:runGeneration()
  debugprint(i..':', pots)
end
local sumAfter20 = pots:sum()
print(sumAfter20)

-- Part 2
-- eventually the filled pots just shift over each generation
-- without changing, so we detect when that happens and
-- extrapolate for the remaining iterations
local N = 50000000000
local lastState, lastSum = pots:stringState(), sumAfter20
local loopStart, loopDelta
for i=21,N do
  pots:runGeneration()
  local curState = pots:stringState()
  if curState == lastState then
    loopStart = i-1
    loopDelta = pots:sum() - lastSum
    break
  end
  lastState = curState
  lastSum = pots:sum()
end
debugprint('loop detected at iteration '..loopStart..' with loop delta '..loopDelta)
debugprint('looping pattern: ' .. pots:stringState())
local remainingIterations = N - loopStart
local finalSum = lastSum + remainingIterations * loopDelta
print(finalSum)
