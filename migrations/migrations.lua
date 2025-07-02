for _,force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes
  local mods = script.active_mods

  if technologies["cerys-advanced-structure-repair"] and technologies["cerys-advanced-structure-repair"].researched then
    recipes["cerys-upgrade-fulgoran-moon-garden-quality"].enabled = true
  end
  if mods["bztin"] then
    if technologies["cerys-nitrogen-rich-mineral-processing"] and technologies["cerys-nitrogen-rich-mineral-processing"].researched then
      recipes["alternative-nitrogen-rich-mineral-processing"].enabled = true
    end
  end
end
