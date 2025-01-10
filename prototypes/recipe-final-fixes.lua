data.raw.recipe["liquid-fertilizer"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
data.raw.recipe["bioslurry-recycling"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
if settings.startup["astroponics-crude-oil"].value then
  data.raw.recipe["bioslurry-putrefaction"].category = "chemistry-or-cryogenics-or-fulgoran-cryogenics"
end

if mods["bztin"] then
  data.raw.recipe["organotins"].category = "chemistry-or-fulgoran-cryogenics"
end
