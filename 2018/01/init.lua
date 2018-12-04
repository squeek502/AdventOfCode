local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local sum = 0
for i, v in ipairs(input) do
  sum = sum + tonumber(v)
end

print(sum)
