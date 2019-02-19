local input = io.open('input.txt'):read('*l')

local Node = {}
Node.__index = Node

function Node.new()
  local self = setmetatable({}, Node)
  self.children = {}
  self.metadata = {}
  return self
end

local function parse(inputs, i)
  if i == nil then i = 1 end

  local numChildren = inputs[i]
  local numMetadata = inputs[i+1]
  assert(numChildren ~= nil)
  assert(numMetadata ~= nil and numMetadata > 0)

  local node = Node.new()
  local start = i
  i = i+2

  for j=1, numChildren do
    local child, len = parse(inputs, i)
    table.insert(node.children, child)
    i = i + len + 1
  end

  for j=1, numMetadata do
    local metadata = inputs[i]
    table.insert(node.metadata, metadata)
    i = i + 1
  end

  assert(numChildren == #node.children)
  assert(numMetadata == #node.metadata)

  return node, (i-start-1)
end

local inputs = {}
for v in input:gmatch("%d+") do
  table.insert(inputs, tonumber(v))
end
local root = parse(inputs)

local function flatten(node)
  local flat = {}
  table.insert(flat, node)
  for _, child in ipairs(node.children) do
    for _, v in ipairs(flatten(child)) do
      table.insert(flat, v)
    end
  end
  return flat
end

-- Part 1
local sum = 0
for _, node in ipairs(flatten(root)) do
  for _, metadata in ipairs(node.metadata) do
    sum = sum + metadata
  end
end
print(sum)

local function computeValue(root)
  local cache = {}

  local function compute(node)
    -- if its been computed before, just return it
    if cache[node] then return cache[node] end

    local value = 0

    if #node.children == 0 then
      for _, metadata in ipairs(node.metadata) do
        value = value + metadata
      end
    else
      for _, metadata in ipairs(node.metadata) do
        local child = node.children[metadata]
        if child then
          value = value + compute(child)
        end
      end
    end

    cache[node] = value
    return value
  end

  return compute(root)
end

-- Part 2
print(computeValue(root))
