local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

local instructions = {
  ['('] = function(floor) return floor + 1 end,
  [')'] = function(floor) return floor - 1 end,
}

local floor = 0
local enteredBasement = nil
local pos = 1
for c in input:gmatch('.') do
  floor = instructions[c](floor)
  if floor < 0 and not enteredBasement then
    enteredBasement = pos
  end
  pos = pos + 1
end

print("Part 1", floor)
print("Part 2", enteredBasement)
