local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local molecule = table.remove(input)
table.remove(input) -- blank line

local replacements = {}
for _, line in ipairs(input) do
  local needle, rep = line:match("(%w+) => (%w+)")
  if not replacements[needle] then replacements[needle] = {} end
  table.insert(replacements[needle], rep)
end

local function tryReplace(str, start, needle, rep)
  if str:sub(start, start+#needle-1) == needle then
    return str:sub(1,start-1) .. rep .. str:sub(start+#needle)
  end
end

local function getDistinctMolecules(molecule, replacements)
  local distinct = {}
  local count = 0
  for k,v in pairs(replacements) do
    for _,rep in ipairs(v) do
      for i=1,#molecule do
        local new = tryReplace(molecule, i, k, rep)
        if new then
          if not distinct[new] then
            count = count+1
          end
          distinct[new] = true
        end
      end
    end
  end
  return count, distinct
end

local count = getDistinctMolecules(molecule, replacements)
print(count)

-- Part 2
local reverseReplacements = {}
local origins = {}
for k,v in pairs(replacements) do
  for _,rep in ipairs(v) do
    if k ~= "e" then
      reverseReplacements[rep] = k
    else
      origins[rep] = k
    end
  end
end

-- sorting by the delta here seems to lead to a quick solve by happenstance (?)
-- using the same solve algorithm but sorting by replacement length leads to
-- a really long solve time
local sortedByDelta = {}
for k in pairs(reverseReplacements) do
  table.insert(sortedByDelta,k)
end
table.sort(sortedByDelta, function(a,b)
  local da = #a - #reverseReplacements[a]
  local db = #b - #reverseReplacements[b]
  return da > db
end)

local function makeMolecule(target)
  local seen = {}
  local make

  make = function(target, steps)
    if steps == nil then steps = 0 end
    seen[target] = true
    steps = steps+1

    if origins[target] then
      return steps
    end

    for _, k in ipairs(sortedByDelta) do
      local rep = reverseReplacements[k]
      for i=1,#target do
        local new = tryReplace(target, i, k, rep)
        if new and not seen[new] then
          local total = make(new, steps)
          if total then
            return total
          end
        end
      end
    end
  end

  return make(target)
end

local steps = makeMolecule(molecule)
print(steps)
