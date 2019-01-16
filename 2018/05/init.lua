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

local output = react(input)
print(#output)
