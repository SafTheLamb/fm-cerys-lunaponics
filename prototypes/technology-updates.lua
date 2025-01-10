local ftech = require("__fdsl__.lib.technology")

ftech.add_unlock("cerys-cryogenic-plant-quality-upgrades", "cerys-upgrade-fulgoran-moon-garden-quality")

if mods["bztin"] then
  ftech.add_unlock("cerys-nitrogen-rich-mineral-processing", "alternative-nitrogen-rich-mineral-processing")
end