local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local instructions = {}
for _, instruction in ipairs(input) do
  local reg, op, v, regCond, cond, vCond = instruction:match("(%w+) (%w+) ([%d-]+) if (%w+) ([!>=<]+) ([%d-]+)")
  v, vCond = tonumber(v), tonumber(vCond)
  table.insert(instructions, {
    register=reg,
    operation=op,
    value=v,
    condition = {register=regCond, condition=cond, value=vCond}
  })
end

local operations = {
  inc = function(cur, v) return cur + v end,
  dec = function(cur, v) return cur - v end,
}

local conditions = {
  [">"] = function(a, b) return a > b end,
  [">="] = function(a, b) return a >= b end,
  ["<"] = function(a, b) return a < b end,
  ["<="] = function(a, b) return a <= b end,
  ["=="] = function(a, b) return a == b end,
  ["!="] = function(a, b) return a ~= b end,
}

local registers = {}
local function get(reg) return registers[reg] or 0 end

for _, instruction in ipairs(instructions) do
  local condition = instruction.condition
  local condfn = conditions[condition.condition]
  if condfn(get(condition.register), condition.value) then
    local opfn = operations[instruction.operation]
    registers[instruction.register] = opfn(get(instruction.register), instruction.value)
  end
end

local max = -math.huge
for register, v in pairs(registers) do
  if v > max then
    max = v
  end
end
print(max)
