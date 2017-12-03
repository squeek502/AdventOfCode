local function combinations(arr, r, start, data, dataIndex)
  local len = #arr
  local combos = {}
  if r == nil then
    for i=1,len do
      for _, combination in ipairs(combinations(arr, i)) do
        table.insert(combos, combination)
      end
    end
    return combos
  end
  if data == nil then data = {} end
  if start == nil then start = 1 end
  if dataIndex == nil then dataIndex = 1 end

  if dataIndex > r then
    local combination = {}
    for j=1,r do
      table.insert(combination, data[j])
    end
    return {combination}
  end

  local arrIndex = start
  while arrIndex <= len and len-arrIndex >= r-dataIndex do
    data[dataIndex] = arr[arrIndex]
    for _, combination in ipairs(combinations(arr, r, arrIndex+1, data, dataIndex+1)) do
      table.insert(combos, combination)
    end
    arrIndex = arrIndex+1
  end

  return combos
end

return combinations
