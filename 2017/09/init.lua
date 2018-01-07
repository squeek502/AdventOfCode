local input = io.open('input.txt'):read('*l')

local Stack = {}
Stack.__index = Stack

function Stack.new()
  local self = setmetatable({}, Stack)
  self.stack = {}
  return self
end

function Stack:push(v)
  table.insert(self.stack, v)
end

function Stack:pop()
  local v = table.remove(self.stack, #self.stack)
  return v
end

function Stack:peek()
  return self.stack[#self.stack]
end

function Stack:len()
  return #self.stack
end

local groups = Stack.new()
local garbage = false
local ignored = false
local score = 0
local garbageCount = 0
for i=1,#input do
  local char = input:sub(i,i)
  if garbage then
    if not ignored then
      if char == "!" then
        ignored = true
      elseif char == ">" then
        garbage = false
      else
        garbageCount = garbageCount + 1
      end
    else
      ignored = false
    end
  elseif char == "<" then
    garbage = true
  elseif char == "{" then
    groups:push(char)
    score = score + groups:len()
  elseif char == "}" then
    groups:pop()
  end
end
assert(groups:len() == 0, "imbalanced groups")

print(score)
print(garbageCount)
