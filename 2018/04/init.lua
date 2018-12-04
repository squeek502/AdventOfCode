local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function mapArrayInPlace(tbl, fn)
  for i, v in ipairs(tbl) do
    tbl[i] = fn(v)
  end
  return tbl
end

local function parseTimestamp(timestamp)
  return unpack(mapArrayInPlace({timestamp:match("(%d+)-(%d+)-(%d+) (%d+):(%d+)")}, tonumber))
end

local function intdiv(a, b)
  return math.floor(a/b)
end

local function jdn(timestamp)
  local y, m, d, hr, min = parseTimestamp(timestamp)
  local jdn = intdiv(1461 * (y + 4800 + intdiv((m - 14),12)),4) + intdiv((367 * (m - 2 - 12 * intdiv((m - 14),12))),12) - (3 * intdiv((y + 4900 + intdiv(intdiv(m - 14,12),100)),4)) + d - 32075
  local time = hr*60 + min
  return jdn, time
end

local epochJDN = 0
local function epochMinutes(timestamp)
  local jdn, mins = jdn(timestamp)
  return (jdn - epochJDN) * 60*24 + mins
end

local events = {}
local timestamps = {}
for _, line in ipairs(input) do
  local timestamp, action = line:match("%[([^]]+)%] (.+)")
  events[timestamp] = action
  table.insert(timestamps, timestamp)
end

table.sort(timestamps)
epochJDN = jdn(timestamps[1])

local guard
local lastEvent
local amountSlept = {}
for i=1,#timestamps do
  local timestamp = timestamps[i]
  local time = epochMinutes(timestamp)
  local event = events[timestamp]
  if event:match("^Guard") then
    guard = tonumber(event:match("Guard #(%d+) begins shift"))
  elseif event == "wakes up" then
    local timeAsleep = time - lastEvent
    amountSlept[guard] = (amountSlept[guard] or 0) + timeAsleep
  end
  lastEvent = time
end

local maxSleep, sleepiest = -math.huge, nil
for id, amount in pairs(amountSlept) do
  if amount > maxSleep then
    sleepiest = id
    maxSleep = amount
  end
end

local sleepiestSchedule = {}
for i=1,#timestamps do
  local timestamp = timestamps[i]
  local time = epochMinutes(timestamp)
  local event = events[timestamp]
  if event:match("^Guard") then
    guard = tonumber(event:match("Guard #(%d+) begins shift"))
  elseif event == "wakes up" then
    if guard == sleepiest then
      for min=lastEvent, time-1 do
        sleepiestSchedule[min % 60] = (sleepiestSchedule[min % 60] or 0) + 1
      end
    end
  end
  lastEvent = time
end

local maxAmount, maxMin = 0, nil
for min, amount in pairs(sleepiestSchedule) do
  if amount > maxAmount then
    maxAmount = amount
    maxMin = min
  end
end

print(sleepiest * maxMin)
