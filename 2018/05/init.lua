local input = io.open('input.txt'):read('*l')

local function isReaction(a, b)
  return a and b and a ~= b and a:lower() == b:lower()
end

local function react(str)
  local stack = {}
  for i=1,#str do
    local char = str:sub(i,i)
    if isReaction(char, stack[#stack]) then
      table.remove(stack)
    else
      table.insert(stack, char)
    end
  end
  return table.concat(stack)
end

-- Part 1
local output = react(input)
print(#output)

-- Part 2
local min = math.huge
for byte=string.byte('a'),string.byte('z') do
  local char = string.char(byte)
  local str = output:gsub('['..char..char:upper()..']+', '')
  local reacted = react(str)
  if #reacted < min then
    min = #reacted
  end
end
print(min)
