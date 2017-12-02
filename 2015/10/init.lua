local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

local function lookAndSay(str)
  local new = {}
  local i = 1
  local len = #str
  repeat
    local count, digit = 1, str:sub(i,i)
    while str:sub(i+count,i+count) == digit do
      count = count + 1
    end
    table.insert(new, count)
    table.insert(new, digit)
    i = i+count
  until i > len
  return table.concat(new)
end

local function iterate(input, rounds)
  local new
  for i=1, rounds do
    new = lookAndSay(input)
    input = new
  end
  return new
end

local output = iterate(input, 40)
print(#output)

output = iterate(input, 50)
print(#output)
