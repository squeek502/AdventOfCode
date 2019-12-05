local input = io.open('input.txt'):read('*l')

local function split(str)
   local fields = {}
   str:gsub("([^,]+)", function(c) fields[#fields+1] = c end)
   return fields
end

local function load()
  local vals = {}
  local index = 0
  for _, val in ipairs(split(input)) do
    vals[index] = tonumber(val)
    index = index + 1
  end
  return vals
end

local INPUT = 1
local OUTPUT = {}
local MODES = {
  POSITION = 0,
  IMMEDIATE = 1,
}
local DEFAULT_MODE = MODES.POSITION

local function getParam(vals, index, mode)
  if not mode then mode = DEFAULT_MODE end
  local val = vals[index]
  if mode == MODES.POSITION then
    val = vals[val]
  end
  return val
end

local function output(val)
  table.insert(OUTPUT, val)
end

local opcodes = {
  [1] = function(vals, index, modes)
    local a, b, c = getParam(vals, index+1, modes[1]), getParam(vals, index+2, modes[2]), vals[index+3]
    vals[c] = a + b
    return index+4
  end,
  [2] = function(vals, index, modes)
    local a, b, c = getParam(vals, index+1, modes[1]), getParam(vals, index+2, modes[2]), vals[index+3]
    vals[c] = a * b
    return index+4
  end,
  [3] = function(vals, index, modes)
    local dest = vals[index+1]
    vals[dest] = INPUT
    return index+2
  end,
  [4] = function(vals, index, modes)
    local val = getParam(vals, index+1, modes[1])
    output(val)
    return index+2
  end,
  -- jump-if-true
  [5] = function(vals, index, modes)
    local a, b = getParam(vals, index+1, modes[1]), getParam(vals, index+2, modes[2])
    if a ~= 0 then
      return b
    else
      return index+3
    end
  end,
  -- jump-if-false
  [6] = function(vals, index, modes)
    local a, b = getParam(vals, index+1, modes[1]), getParam(vals, index+2, modes[2])
    if a == 0 then
      return b
    else
      return index+3
    end
  end,
  -- less than
  [7] = function(vals, index, modes)
    local a, b, c = getParam(vals, index+1, modes[1]), getParam(vals, index+2, modes[2]), vals[index+3]
    if a < b then
      vals[c] = 1
    else
      vals[c] = 0
    end
    return index+4
  end,
  -- equals
  [8] = function(vals, index, modes)
    local a, b, c = getParam(vals, index+1, modes[1]), getParam(vals, index+2, modes[2]), vals[index+3]
    if a == b then
      vals[c] = 1
    else
      vals[c] = 0
    end
    return index+4
  end,
  -- halt
  [99] = function(vals, index, modes)
    return nil
  end
}

local function run(vals)
  local position = 0
  while true do
    local cur = vals[position]
    local fullOpcode = tostring(cur)
    local opcode = fullOpcode:match("(%d?%d)$")
    local modesString = fullOpcode:gsub(opcode.."$", "")
    local modes = {}
    local paramNum = 1
    for i=#modesString, 1, -1 do
      modes[paramNum] = tonumber(modesString:sub(i,i))
      paramNum = paramNum + 1
    end
    local fn = assert(opcodes[tonumber(opcode)], "invalid opcode: "..opcode.." (from "..fullOpcode..")")
    position = fn(vals, position, modes)
    if not position then
      break
    end
  end

  return OUTPUT[#OUTPUT]
end

-- Part 1
INPUT = 1
local result = run(load())
print(result)

-- Part 2
INPUT = 5
result = run(load())
print(result)
