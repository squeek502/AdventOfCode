local bit = require('bit')

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

local function parse(line)
  local input = line:match("^[a-z%d]+")
  if tonumber(input) ~= nil then input = tonumber(input) end
  local op = line:match("([A-Z]+)")
  local arg = line:match("([a-z%d]+) %->")
  if tonumber(arg) ~= nil then arg = tonumber(arg) end
  local out = line:match("-> ([a-z]+)$")
  return input, op, arg, out
end

local operations = {
  ["AND"] = function(a, b) return bit.band(a, b) end,
  ["OR"] = function(a, b) return bit.bor(a, b) end,
  ["LSHIFT"] = function(a, b) return bit.lshift(a, b) end,
  ["RSHIFT"] = function(a, b) return bit.rshift(a, b) end,
  ["NOT"] = function(_, b) return bit.bnot(b) end
}

local Circuit = {}
Circuit.__index = Circuit

function Circuit.new()
  local self = setmetatable({}, Circuit)
  self.signals = {}
  self.connections = {}
  return self
end

function Circuit:resolve(v)
  if type(v) == "string" then
    if self.signals[v] then return self.signals[v] end
    local source = self.connections[v]
    self.signals[v] = self:process(unpack(source))
    return self.signals[v]
  end
  return v
end

function Circuit:process(input, op, arg)
  local result = self:resolve(input)
  if op then
    result = operations[op](result, self:resolve(arg))
    -- restrict result to 16 bits
    result = bit.band(result, 0xffff)
  end
  return result
end

function Circuit:assemble(input)
  self.connections = {}
  for _, line in ipairs(input) do
    local input, op, arg, out = parse(line)
    self.connections[out] = {input, op, arg}
  end
end

local circuit = Circuit.new()
circuit:assemble(input)
local a = circuit:resolve('a')
print('a', a)

circuit.signals = {['b'] = a}
a = circuit:resolve('a')
print('a', a)
