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

local patternEscapes = {
  ["^"] = "%^", ["$"] = "%$", ["("] = "%(", [")"] = "%)",
  ["%"] = "%%", ["."] = "%.", ["["] = "%[", ["]"] = "%]",
  ["*"] = "%*", ["+"] = "%+", ["-"] = "%-", ["?"] = "%?",
  ["\0"] = "%z",
}
local function escapePattern(s)
  return (s:gsub(".", patternEscapes))
end

local function gsubPlain(haystack, needle, repl)
  return haystack:gsub(escapePattern(needle), repl)
end

local function getInners(str)
  str = str:sub(2,-2)
  local inners = {}
  for inner in str:gmatch("%b{}") do
    table.insert(inners, inner)
  end
  return inners
end

local function stripRed(str)
  str = str:gsub("%b{}", function(obj)
    local inners = getInners(obj)
    for _, inner in ipairs(inners) do
      local strippedInner = stripRed(inner)
      obj = gsubPlain(obj, inner, strippedInner)
    end
    if obj:match(":\"red\"") then
      return ""
    else
      return obj
    end
  end)
  return str
end

input = stripRed(input)

sum = 0
for number in input:gmatch("[%d%-]+") do
  number = tonumber(number)
  sum = sum + number
end
print(sum)
