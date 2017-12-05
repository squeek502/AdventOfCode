local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local instructions = {}
for _, line in ipairs(input) do
  local jmp = tonumber(line)
  table.insert(instructions, jmp)
end

local cur, steps = 1, 0
while cur <= #instructions do
  local jmp = instructions[cur]
  instructions[cur] = jmp+1
  cur = cur + jmp
  steps = steps+1
end

print(steps)

instructions = {}
for _, line in ipairs(input) do
  local jmp = tonumber(line)
  table.insert(instructions, jmp)
end

cur, steps = 1, 0
while cur <= #instructions do
  local jmp = instructions[cur]
  instructions[cur] = jmp >= 3 and jmp-1 or jmp+1
  cur = cur + jmp
  steps = steps+1
end

print(steps)
