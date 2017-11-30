local get = function(path)
  local f = io.open(path, "r")
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end
local input = get('input.txt')

local needed = 0

for _,line in ipairs(input) do
  local l, w, h = line:match("(%d+)x(%d+)x(%d+)")
  l, w, h = tonumber(l), tonumber(w), tonumber(h)
  local surfaceArea = 2*l*w + 2*w*h + 2*h*l
  local slack = math.min(l*w, w*h, h*l)
  needed = needed + surfaceArea + slack
end

print("Total sqft needed", needed)
