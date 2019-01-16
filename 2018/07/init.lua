local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local requirements = {}
for _, line in ipairs(input) do
  local dependency, dependent = line:match("Step (%w) must be finished before step (%w) can begin.")
  requirements[dependent] = requirements[dependent] or {}
  requirements[dependency] = requirements[dependency] or {}
  table.insert(requirements[dependent], dependency)
end

local function requirementsMet(requirements, finished)
  for _, req in ipairs(requirements) do
    if not finished[req] then
      return false
    end
  end
  return true
end

local function getAvailable(requirements, finished)
  local available = {}
  for dependent, dependencies in pairs(requirements) do
    if not finished[dependent] and requirementsMet(dependencies, finished) then
      table.insert(available, dependent)
    end
  end
  return available
end

local function chooseNextStep(available)
  if #available > 1 then
    table.sort(available)
  end
  return available[1]
end

local finished = {}
local available = getAvailable(requirements, finished)

local order = {}
while #available > 0 do
  local step = chooseNextStep(available)
  finished[step] = true
  table.insert(order, step)
  available = getAvailable(requirements, finished)
end
print(table.concat(order))
