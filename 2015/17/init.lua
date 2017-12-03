local combinations = require('combinations')

local get = function(path)
  local lines = {}
  for line in io.lines(path) do
    table.insert(lines, line)
  end
  return lines
end
local input = get('input.txt')

local sizes = {}

for _, line in ipairs(input) do
  table.insert(sizes, tonumber(line))
end

local function filterCombos(combos, target)
  local valid = {}
  for i,combo in ipairs(combos) do
    local sum = 0
    for _,size in ipairs(combo) do
      sum = sum + size
    end
    if sum == target then
      table.insert(valid, combo)
    end
  end
  return valid
end

local combos = combinations(sizes)
combos = filterCombos(combos, 150)
print(#combos)
