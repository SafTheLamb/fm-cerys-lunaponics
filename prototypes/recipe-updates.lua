local frep = require("__fdsl__.lib.recipe")

if settings.startup["astroponics-crude-oil"].value then
  frep.add_category("bioslurry-putrefaction", "fulgoran-cryogenics")
end

if mods["bztin"] then
  frep.add_category("organotins", "fulgoran-cryogenics")
end
