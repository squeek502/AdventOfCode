local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local info = {}
for _,line in ipairs(input) do
  local name, weight = line:match("^(%w+) %((%d+)%)")
  local holdingStr = line:match("-> (.+)$")
  local holding = {}
  if holdingStr then
    for thing in holdingStr:gmatch('%w+') do
      table.insert(holding, thing)
    end
  end
  info[name] = {weight=tonumber(weight), holding=holding}
end

local function node(name, leafs)
  return {name=name, leafs=leafs or {}}
end

local function makeTree(name, info)
  local leafs = {}
  for _,leafname in ipairs(info[name].holding) do
    table.insert(leafs, makeTree(leafname, info))
  end
  return node(name, leafs)
end

local function findHolderRecursively(tofind, info)
  for holder, properties in pairs(info) do
    for _, held in ipairs(properties.holding) do
      if held == tofind then
        return findHolderRecursively(holder, info)
      end
    end
  end
  return tofind
end

local function construct(info)
  for name, properties in pairs(info) do
    if #properties.holding == 0 then
      local origin = findHolderRecursively(name, info)
      return makeTree(origin, info)
    end
  end
end

-- Part 1
local tree = construct(info)
local origin = tree.name
print(origin)

-- Part 2
local getWeight; function getWeight(node)
  local weight = info[node.name].weight
  for _, leaf in ipairs(node.leafs) do
    weight = weight + getWeight(leaf)
  end
  return weight
end

local findDeepestImbalance; function findDeepestImbalance(node)
  for _, leaf in pairs(node.leafs) do
    if findDeepestImbalance(leaf) then
      return leaf
    end
  end
  local expectedWeight = nil
  for _, leaf in pairs(node.leafs) do
    local actualWeight = getWeight(leaf)
    expectedWeight = expectedWeight or actualWeight
    if expectedWeight ~= actualWeight then
      return node
    end
  end
end

local imbalanced = findDeepestImbalance(tree)
local weightFrequency = {}
for _, leaf in ipairs(imbalanced.leafs) do
  local weight = getWeight(leaf)
  if not weightFrequency[weight] then weightFrequency[weight] = {} end
  table.insert(weightFrequency[weight], leaf.name)
end

local mostCommonWeight
local incorrectLeaf, incorrectWeight
for weight, nodes in pairs(weightFrequency) do
  if #nodes == 1 then
    incorrectLeaf, incorrectWeight = nodes[1], weight
  else
    assert(mostCommonWeight == nil, "more than 2 different weights on imbalanced disc")
    mostCommonWeight = weight
  end
end

local diff = mostCommonWeight - incorrectWeight
print(info[incorrectLeaf].weight + diff)
