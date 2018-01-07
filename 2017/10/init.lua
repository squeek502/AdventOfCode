local input = io.open('input.txt'):read('*l')

local lengths = {}
for length in input:gmatch("(%d+)") do
  table.insert(lengths, tonumber(length))
end

local function makeList(length)
  local list = {}
  for i=0,length-1 do
    table.insert(list, i)
  end
  return list
end

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local function reverse(tbl, start, len)
  local finish = start+len-1
  for i=start, start+math.floor((len-1)/2) do
    local j, k = modIndex(i, #tbl), modIndex(finish - (i-start), #tbl)
    local tmp = tbl[j]
    tbl[j] = tbl[k]
    tbl[k] = tmp
  end
end

local function hash(list, lengths)
  local curpos = 1
  local skipsize = 0
  for _, length in ipairs(lengths) do
    reverse(list, curpos, length)
    curpos = (curpos + length + skipsize) % #list
    skipsize = skipsize + 1
  end
  return list[1] * list[2]
end

local list = makeList(256)
print(hash(list, lengths))
