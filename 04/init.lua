local md5 = require('md5')

local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

print(input)

local i = 1
while true do
  local sum = md5.sumhexa(input .. i)
  if sum:match('^00000.*') then
    break
  end
  i = i+1
end

print(i)
