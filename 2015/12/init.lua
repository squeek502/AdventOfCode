local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

local sum = 0
for number in input:gmatch("[%d%-]+") do
  number = tonumber(number)
  sum = sum + number
end
print(sum)
