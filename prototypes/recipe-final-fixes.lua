local function update_recipe_category(recipe_name)
  if data.raw.recipe[recipe_name] then
    local new_category = data.raw.recipe[recipe_name].category.."-or-fulgoran-cryogenics"
    if data.raw["recipe-category"][new_category] then
      data.raw.recipe[recipe_name].category = new_category
    end
  end
end

update_recipe_category("liquid-fertilizer")
update_recipe_category("bioslurry-recycling")
if settings.startup["astroponics-crude-oil"].value then
  update_recipe_category("bioslurry-putrefaction")
end

if mods["bztin"] then
  update_recipe_category("organotins")
end
