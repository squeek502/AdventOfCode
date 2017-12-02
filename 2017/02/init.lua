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

local rows = {}
for _,line in ipairs(input) do
  local nums = {}
  for num in line:gmatch('%d+') do
    num = tonumber(num)
    table.insert(nums, num)
  end
  table.insert(rows, nums)
end

-- Part 1
local differences = 0

for _,nums in ipairs(rows) do
  local smallest = math.min(unpack(nums))
  local largest = math.max(unpack(nums))
  differences = differences + (largest - smallest)
end

print("Part 1", differences)

-- Part 2
local function findDivision(num, nums)
  for _, other in ipairs(nums) do
    if other ~= num then
      local big, small = math.max(other, num), math.min(other, num)
      if big % small == 0 then
        return big / small
      end
    end
  end
  return nil
end

local divisions = 0

for _,nums in ipairs(rows) do
  for _, num in ipairs(nums) do
    local result = findDivision(num, nums)
    if result then
      divisions = divisions + result
      break
    end
  end
end

print("Part 2", divisions)
