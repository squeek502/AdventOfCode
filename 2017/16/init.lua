local input = io.open('input.txt'):read('*l')

local function makeLine(num)
  local programs = {}
  for i=1,num do
    local b = string.byte('a') + (i-1)
    table.insert(programs, string.char(b))
  end
  return programs
end

local function spin(tbl, X)
  for i=1,X do
    local v = table.remove(tbl, #tbl)
    table.insert(tbl, 1, v)
  end
end

local function exchange(tbl, A, B)
  local ai, ab = A, B
  tbl[ai], tbl[ab] = tbl[ab], tbl[ai]
end

local function find(tbl, needle)
  for k,v in ipairs(tbl) do
    if v == needle then return k end
  end
end

local danceMoves = {
  ['s(%d+)'] = function(tbl, X) return spin(tbl, tonumber(X)) end,
  ['x(%d+)/(%d+)'] = function(tbl, A, B) return exchange(tbl, tonumber(A)+1, tonumber(B)+1) end,
  ['p(%w)/(%w)'] = function(tbl, A, B) return exchange(tbl, find(tbl, A), find(tbl, B)) end,
}

local function dance(tbl, move)
  for pattern, fn in pairs(danceMoves) do
    local args = {move:match(pattern)}
    if #args > 0 then
      return fn(tbl, unpack(args))
    end
  end
end

-- Part 1
local programs = makeLine(16)
local start = table.concat(programs)
local memorizedDance = {}
for move in input:gmatch("([^,]+)") do
  dance(programs, move)
  table.insert(memorizedDance, move)
end
print(table.concat(programs))

-- Part 2
local cycleSize
local states = {[1] = table.concat(programs)}
for i=2,1000000000 do
  for _, move in ipairs(memorizedDance) do
    dance(programs, move)
  end
  local state = table.concat(programs)
  if state == start then
    cycleSize = i
    break
  end
  states[i] = state
end

assert(cycleSize, "no cycle found")
print(states[1000000000 % cycleSize])
