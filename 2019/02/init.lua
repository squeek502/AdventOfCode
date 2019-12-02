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

local opcodes = {
  [1] = function(vals, index)
    local a, b, c = vals[index+1], vals[index+2], vals[index+3]
    vals[c] = vals[a] + vals[b]
    return index+4
  end,
  [2] = function(vals, index)
    local a, b, c = vals[index+1], vals[index+2], vals[index+3]
    vals[c] = vals[a] * vals[b]
    return index+4
  end,
  [99] = function(vals, index)
    return nil
  end
}

local function run(vals, noun, verb)
  vals[1] = noun
  vals[2] = verb

  local position = 0
  while true do
    local cur = vals[position]
    position = opcodes[cur](vals, position)
    if not position then
      break
    end
  end

  return vals[0], 100 * noun + verb
end

-- Part 1
-- restore the 1202 program alarm state
local result = run(load(), 12, 2)
print(result)

-- Part 2
local function findResult(n)
  local code
  for noun=0,99 do
    for verb=0,99 do
      result, code = run(load(), noun, verb)
      if result == n then
        return code
      end
    end
  end
end
print(findResult(19690720))
