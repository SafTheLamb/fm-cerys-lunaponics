for _,force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

  recipes["cerys-upgrade-fulgoran-moon-garden-quality"].enabled = technologies["cerys-cryogenic-plant-quality-upgrades"].researched
  recipes["alternative-nitrogen-rich-mineral-processing"].enabled = technologies["cerys-nitrogen-rich-mineral-processing"].researched
end
