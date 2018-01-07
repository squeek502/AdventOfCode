local input = io.open('input.txt'):read('*l')
local knothash = require('day10')

local usedCounts = {
  ['0'] = 0,
  ['1'] = 1,
  ['2'] = 1,
  ['3'] = 2,
  ['4'] = 1,
  ['5'] = 2,
  ['6'] = 2,
  ['7'] = 3,
  ['8'] = 1,
  ['9'] = 2,
  ['a'] = 2,
  ['b'] = 3,
  ['c'] = 2,
  ['d'] = 3,
  ['e'] = 3,
  ['f'] = 4,
}

local used = 0
for i=0,127 do
  local key = string.format("%s-%d", input, i)
  local hash = knothash(key)
  for c in hash:gmatch('.') do
    used = used + usedCounts[c]
  end
end
print(used)
