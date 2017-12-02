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

local function parse(str)
  str = str:sub(2,-2)
  str = str:gsub("\\\"", "\"")
  str = str:gsub("\\x(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
  str = str:gsub("\\\\", "\\")
  return str
end

local unparsed = 0
local parsed = 0

for _, line in ipairs(input) do
  local parsedLine = parse(line)
  unparsed = unparsed + #line
  parsed = parsed + #parsedLine
end

print(unparsed - parsed)
