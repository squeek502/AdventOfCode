local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

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
  self.state = newState
end

function Pots:__tostring()
  local state = {self.minIndex,':'}
  for i=self.minIndex,self.maxIndex do
    table.insert(state, self.state[i] and '#' or '.')
  end
  table.insert(state, ':')
  table.insert(state, self.maxIndex)
  return table.concat(state)
end

local initialState = table.remove(input, 1):match("initial state: (.*)")
local pots = Pots.new(initialState)

while input[1] == "" do table.remove(input, 1) end
for _, rule in ipairs(input) do
  local pattern, result = rule:match("([^ ]+) => (.)")
  pots:addRule(pattern, result)
end

print('0:', pots)
for i=1,20 do
  pots:runGeneration()
  print(i..':', pots)
end

print(pots:sum())
