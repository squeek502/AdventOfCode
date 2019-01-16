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

local function getAvailable(requirements, finished, inprogress)
  if inprogress == nil then inprogress = {} end
  local available = {}
  for dependent, dependencies in pairs(requirements) do
    if not finished[dependent] and not inprogress[dependent] and requirementsMet(dependencies, finished) then
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

-- Part 1
do
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
end

local function getTimeForStep(step)
  local baseTime = 60
  local addedTime = step:byte() - ('A'):byte() + 1
  return baseTime + addedTime
end

-- Part 2
do
  local timeFinished = {}
  local workers, numWorkers = {}, 5
  local finished = {}
  local curTime = 0

  while true do
    local stillWorking = false
    -- resolve finished steps
    for i=1,numWorkers do
      local step = workers[i]
      if timeFinished[step] ~= nil then
        if curTime >= timeFinished[step] then
          timeFinished[step] = nil
          finished[step] = true
          workers[i] = nil
        else
          stillWorking = true
        end
      end
    end
    -- assign steps to idle workers
    for i=1,numWorkers do
      local step = workers[i]
      if not step then
        step = chooseNextStep(getAvailable(requirements, finished, timeFinished))
        if step then
          workers[i] = step
          timeFinished[step] = curTime + getTimeForStep(step)
          stillWorking = true
        end
      end
    end
    if not stillWorking then
      break
    end
    curTime = curTime + 1
  end

  print(curTime)
end
