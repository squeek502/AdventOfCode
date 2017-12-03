local get = function(path)
  local lines = {}
  for line in io.lines(path) do
    table.insert(lines, line)
  end
  return lines
end
local input = get('input.txt')

local sues = {}

for _, line in ipairs(input) do
  local things = {}
  for thing, num in line:gmatch("(%w+): (%d+)") do
    things[thing] = tonumber(num)
  end
  table.insert(sues, things)
end

local function findMatchingSue(needle)
  for i,sue in ipairs(sues) do
    local matches = true
    for k,v in pairs(needle) do
      if sue[k] ~= nil and
        ((type(v) == "number" and sue[k] ~= v) or
        (type(v) == "function" and not v(sue[k])))
      then
        matches = false
        break
      end
    end
    if matches == true then
      return i
    end
  end
end

-- Part 1
local known = {
  children = 3,
  cats = 7,
  samoyeds = 2,
  pomeranians = 3,
  akitas = 0,
  vizslas = 0,
  goldfish = 5,
  trees = 3,
  cars = 2,
  perfumes = 1
}

local sue = findMatchingSue(known)
print(sue)

-- Part 2
known.cats = function(v) return v > 7 end
known.pomeranians = function(v) return v < 3 end
known.goldfish = function(v) return v < 5 end
known.trees = function(v) return v > 3 end

sue = findMatchingSue(known)
print(sue)
