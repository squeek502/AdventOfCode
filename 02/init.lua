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

local wrappingNeeded = 0
local ribbonNeeded = 0

for _,line in ipairs(input) do
  local l, w, h = line:match("(%d+)x(%d+)x(%d+)")
  l, w, h = tonumber(l), tonumber(w), tonumber(h)

  local surfaceArea = 2*l*w + 2*w*h + 2*h*l
  local slack = math.min(l*w, w*h, h*l)
  wrappingNeeded = wrappingNeeded + surfaceArea + slack

  local smallestSidePerimeter = math.min(l+w, w+h, h+l)*2
  local volume = l*w*h
  ribbonNeeded = ribbonNeeded + smallestSidePerimeter + volume
end

print("Total wrapping needed (sqft)", wrappingNeeded)
print("Total ribbon needed (ft)", ribbonNeeded)
