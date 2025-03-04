local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

data.raw.recipe["lubricant-synthesis"].icon = "__cerys-lunaponics__/graphics/icons/fluid/lubricant-synthesis.png"
frep.replace_ingredient("lubricant-synthesis", "light-oil", "bioslurry")

if mods["bztin"] and data.raw.item["tinned-cable"] then
  frep.replace_result("cerys-nuclear-scrap-recycling", "copper-cable", "tinned-cable")
  frep.scale_result("cerys-nuclear-scrap-recycling", "tinned-cable", {probability=2})
end

ftech.add_unlock("cerys-fulgoran-machine-quality-upgrades", "cerys-upgrade-fulgoran-moon-garden-quality")
ftech.add_unlock("cerys-fulgoran-cryogenics", "cerys-liquid-fertilizer")

if mods["bztin"] then
  ftech.add_unlock("cerys-nitrogen-rich-mineral-processing", "alternative-nitrogen-rich-mineral-processing")
end

local cerys = data.raw.planet["cerys"]
cerys.map_gen_settings.autoplace_settings["entity"].settings["cerys-fulgoran-moon-garden"] = {}

table.insert(data.raw["simple-entity"]["cerys-ruin-small"].minable.results, {type="item", name="tree-seed", amount=1, probability=0.12})
table.insert(data.raw["simple-entity"]["cerys-ruin-medium"].minable.results, {type="item", name="tree-seed", amount=1, probability=0.12})
table.insert(data.raw["simple-entity"]["cerys-ruin-big"].minable.results, {type="item", name="tree-seed", amount=1, probability=0.43})
table.insert(data.raw["simple-entity"]["cerys-ruin-huge"].minable.results, {type="item", name="tree-seed", amount=1})
table.insert(data.raw["simple-entity"]["cerys-ruin-colossal"].minable.results, {type="item", name="tree-seed", amount=2})

table.insert(data.raw["simple-entity"]["cerys-ruin-small"].minable.results, {type="item", name="lumber", amount=3})
table.insert(data.raw["simple-entity"]["cerys-ruin-medium"].minable.results, {type="item", name="lumber", amount=7})
table.insert(data.raw["simple-entity"]["cerys-ruin-big"].minable.results, {type="item", name="lumber", amount_min=10, amount_max=14})
table.insert(data.raw["simple-entity"]["cerys-ruin-huge"].minable.results, {type="item", name="lumber", amount_min=18, amount_max=25})
table.insert(data.raw["simple-entity"]["cerys-ruin-colossal"].minable.results, {type="item", name="lumber", amount_min=32, amount_max=39})

table.insert(data.raw["simple-entity"]["cerys-ruin-small"].minable.results, {type="item", name="low-density-structure", amount=1, probability=0.12})
table.insert(data.raw["simple-entity"]["cerys-ruin-medium"].minable.results, {type="item", name="low-density-structure", amount=1, probability=0.12})
table.insert(data.raw["simple-entity"]["cerys-ruin-big"].minable.results, {type="item", name="low-density-structure", amount=2})
table.insert(data.raw["simple-entity"]["cerys-ruin-huge"].minable.results, {type="item", name="low-density-structure", amount=4})
table.insert(data.raw["simple-entity"]["cerys-ruin-colossal"].minable.results, {type="item", name="low-density-structure", amount=7})
