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

local ingredients = {}

local Ingredient = {}
Ingredient.__index = Ingredient

function Ingredient.new(capacity, durability, flavor, texture, calories)
  local self = setmetatable({}, Ingredient)
  self.capacity = capacity
  self.durability = durability
  self.flavor = flavor
  self.texture = texture
  self.calories = calories
  return self
end

local Recipe = {}
Recipe.__index = Recipe

function Recipe.new(ingredients)
  local self = setmetatable({}, Recipe)
  self.ingredients = ingredients or {}
  self.maxTsps = 100
  return self
end

function Recipe:score()
  local capacity, durability, flavor, texture = 0, 0, 0, 0
  for name, amount in pairs(self.ingredients) do
    local ingredient = ingredients[name]
    capacity = capacity + ingredient.capacity * amount
    durability = durability + ingredient.durability * amount
    flavor = flavor + ingredient.flavor * amount
    texture = texture + ingredient.texture * amount
  end
  return math.max(0, capacity) * math.max(0, durability) * math.max(0, flavor) * math.max(0, texture)
end

function Recipe:addIngredient(name, amount)
  self.ingredients[name] = amount
end

function Recipe:tsps()
  local sum = 0
  for _, v in pairs(self.ingredients) do sum = sum + v end
  return sum
end

function Recipe:tspsAvailable()
  return self.maxTsps - self:tsps()
end

for _, line in ipairs(input) do
  local name, capacity, durability, flavor, texture, calories = line:match("^(%w+): capacity ([%d-]+), durability ([%d-]+), flavor ([%d-]+), texture ([%d-]+), calories ([%d-]+)")
  ingredients[name] = Ingredient.new(tonumber(capacity), tonumber(durability), tonumber(flavor), tonumber(texture), tonumber(calories))
end

local function copy(tbl)
  local cp = {}
  for k,v in pairs(tbl) do cp[k] = v end
  return cp
end

local function pairsCount(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

local function getAvailable()
  local available = {}
  for k,v in pairs(ingredients) do
    available[k] = true
  end
  return available
end

local function getPossibleRecipes(ingredient, recipe, available)
  if ingredient == nil then ingredient = next(ingredients) end
  if recipe == nil then recipe = Recipe.new() end
  if available == nil then available = getAvailable() end
  available = copy(available)
  available[ingredient] = nil

  local recipes = {}
  if pairsCount(available) == 0 then
    recipe:addIngredient(ingredient, recipe:tspsAvailable())
    return {recipe}
  else
    for name in pairs(available) do
      local free = recipe:tspsAvailable()
      for amount=0,free do
        local nextRecipe = Recipe.new(copy(recipe.ingredients))
        nextRecipe:addIngredient(ingredient, amount)
        local future = getPossibleRecipes(name, nextRecipe, available)
        for _, arr in ipairs(future) do
          table.insert(recipes, arr)
        end
      end
    end
  end
  return recipes
end

local recipes = getPossibleRecipes()
local maxScore = -math.huge
for _, recipe in ipairs(recipes) do
  maxScore = math.max(maxScore, recipe:score())
end
print("# possible recipes", #recipes)
print("Part 1", maxScore)
