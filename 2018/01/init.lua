local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local sum = 0
local seen = {[sum] = true}
local firstSum, firstDup

while firstDup == nil do
  for i, v in ipairs(input) do
    sum = sum + tonumber(v)
    if firstDup == nil and seen[sum] ~= nil then
      firstDup = sum
    end
    seen[sum] = true
  end
  if firstSum == nil then
    firstSum = sum
  end
end

-- Part 1
print(firstSum)

-- Part 2
print(firstDup)
