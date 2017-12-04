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
