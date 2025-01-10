for _,force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

  recipes["electric-kiln"].enabled = technologies["cerys-cryogenic-plant-quality-upgrades"].researched
end
