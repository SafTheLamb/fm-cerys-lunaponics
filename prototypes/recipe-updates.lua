local function add_recipe_category(recipe_name, category_name)
  local recipe = data.raw.recipe[recipe_name]
  if recipe then
    if not recipe.additional_categories then
      recipe.additional_categories = {}
    end
    table.insert(recipe.additional_categories, category_name)
  end
end

if settings.startup["astroponics-crude-oil"].value then
  add_recipe_category("bioslurry-putrefaction", "fulgoran-cryogenics")
end

if mods["bztin"] then
  add_recipe_category("organotins", "fulgoran-cryogenics")
end
