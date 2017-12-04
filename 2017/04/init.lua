local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function isValid(phrase)
  local seen = {}
  for word in phrase:gmatch("%w+") do
    if seen[word] then
      return false
    end
    seen[word] = true
  end
  return true
end

local valid = 0
for _,line in ipairs(input) do
  if isValid(line) then
    valid = valid+1
  end
end

print(valid)
