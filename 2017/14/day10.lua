-- from day 10, simplified and exported as a single function

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

local ok, bit = pcall(require, "bit")
if not ok then
  bit = {}
  function bit.bxor(a,b)
    local p,c=1,0
    while a>0 and b>0 do
      local ra,rb=a%2,b%2
      if ra~=rb then c=c+p end
      a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
      local ra=a%2
      if ra>0 then c=c+p end
      a,p=(a-ra)/2,p*2
    end
    return c
  end
end

local function asciiToLengths(ascii)
  local lengths = {}
  for c in ascii:gmatch(".") do
    local n = string.byte(c)
    table.insert(lengths, n)
  end
  table.insert(lengths, 17)
  table.insert(lengths, 31)
  table.insert(lengths, 73)
  table.insert(lengths, 47)
  table.insert(lengths, 23)
  return lengths
end

local function hash(input)
  local lengths = asciiToLengths(input)
  local list = makeList(256)
  local rounds = 64
  local curpos = 1
  local skipsize = 0
  local round = function()
    for _, length in ipairs(lengths) do
      reverse(list, curpos, length)
      curpos = modIndex(curpos + length + skipsize, #list)
      skipsize = skipsize + 1
    end
  end
  for i=1,rounds do
    round()
  end
  local dense = {}
  for i=1,256,16 do
    local n = list[i]
    for j=i+1,i+15 do
      n = bit.bxor(n, list[j])
    end
    table.insert(dense, n)
  end
  local hash = ""
  for _, n in ipairs(dense) do
    hash = hash .. string.format("%02x", n)
  end
  return hash
end

return hash
