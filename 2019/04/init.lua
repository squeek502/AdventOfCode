local input = io.open('input.txt'):read('*l')

local min, max = input:match("(%d+)%-(%d+)")
min, max = tonumber(min), tonumber(max)

local function validate(password)
  local str = tostring(password)
  if #str ~= 6 then return false, false end
  local hasDoubleNumber = false
  local hasExactlyDoubleNumber = false
  str:gsub("(.)%1", function(digit)
    hasDoubleNumber = true
    if not str:find(string.rep(digit, 3)) then
      hasExactlyDoubleNumber = true
    end
  end)
  if not hasDoubleNumber then return false, false end
  local lastDigit
  for i=1,#str do
    local digit = tonumber(str:sub(i,i))
    if lastDigit and digit < lastDigit then
      return false, false
    end
    lastDigit = digit
  end
  return true, hasExactlyDoubleNumber
end

do
  -- sanity test case
  local loose, strict = validate(111122)
  assert(loose, "111122 fails loose validation")
  assert(strict, "111122 fails strict validation")
end

local numValid1, numValid2 = 0, 0
for i=min,max do
  local loose, strict = validate(i)
  if loose then
    numValid1 = numValid1 + 1
  end
  if strict then
    numValid2 = numValid2 + 1
  end
end

-- Part 1
print(numValid1)
-- Part 2
print(numValid2)
