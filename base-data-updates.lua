local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

if mods["bztin"] and data.raw.item["tinned-cable"] then
  frep.replace_result("cerys-nuclear-scrap-recycling", "copper-cable", "tinned-cable")
  frep.scale_result("cerys-nuclear-scrap-recycling", "tinned-cable", {probability=2})
end

table.insert(data.raw["simple-entity"]["cerys-ruin-small"].minable.results, {type="item", name="tree-seed", amount=1, probability=0.17})
table.insert(data.raw["simple-entity"]["cerys-ruin-medium"].minable.results, {type="item", name="tree-seed", amount=1, probability=0.56})
table.insert(data.raw["simple-entity"]["cerys-ruin-big"].minable.results, {type="item", name="tree-seed", amount=1})
table.insert(data.raw["simple-entity"]["cerys-ruin-huge"].minable.results, {type="item", name="tree-seed", amount=2})
table.insert(data.raw["simple-entity"]["cerys-ruin-colossal"].minable.results, {type="item", name="tree-seed", amount=5})

local cerys = data.raw.planet["cerys"]
cerys.map_gen_settings.autoplace_settings["entity"].settings["cerys-fulgoran-moon-garden"] = {}

ftech.add_unlock("cerys-cryogenic-plant-quality-upgrades", "cerys-upgrade-fulgoran-moon-garden-quality")

if mods["bztin"] then
  ftech.add_unlock("cerys-nitrogen-rich-mineral-processing", "alternative-nitrogen-rich-mineral-processing")
end
