for _,force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes
  local mods = script.active_mods

  recipes["cerys-upgrade-fulgoran-moon-garden-quality"].enabled = technologies["cerys-fulgoran-machine-quality-upgrades"].researched
  if mods["bztin"] then
    recipes["alternative-nitrogen-rich-mineral-processing"].enabled = technologies["cerys-nitrogen-rich-mineral-processing"].researched
    
  end
end
