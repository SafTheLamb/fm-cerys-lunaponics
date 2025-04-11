local merge = require("__Cerys-Moon-of-Fulgora__.lib").merge

local moon_garden = merge(data.raw["assembling-machine"]["space-garden"], {
  name = "cerys-fulgoran-moon-garden",
  icon = "__cerys-lunaponics__/graphics/icons/moon-garden.png",
  subgroup = "cerys-entities",
  order = "g",
  max_health = 25000,
  crafting_categories = {
    "astroponics",
    "fulgoran-lunaponics"
  },
  next_upgrade = "nil",
  fast_replaceable_group = "cerys-fulgoran-moon-garden",
  minable = {mining_time=1, result="cerys-fulgoran-moon-garden"},
  autoplace = {
    probability_expression = "0",
  },
  map_color = {17, 204, 102},
})
moon_garden.graphics_set.animation.layers[1].filename = "__cerys-lunaponics__/graphics/entity/moon-garden/moon-garden.png"
moon_garden.graphics_set.working_visualisations[1].animation.filename = "__cerys-lunaponics__/graphics/entity/moon-garden/moon-garden-working.png"
moon_garden.surface_conditions = nil

local wreck = merge(moon_garden, {
  name = "cerys-fulgoran-moon-garden-wreck",
  hidden_in_factoriopedia = true,
  crafting_categories = {"moon-garden-repair"},
  fixed_recipe = "cerys-repair-moon-garden",
  crafting_speed = 1,
  energy_source = {
		type = "void",
	},
  module_slots = 1,
  allowed_effects = {"speed", "productivity"},
  map_color = { 150, 250, 200 },
  working_sound = {
    sound = {filename="__base__/sound/assembling-machine-t2-1.ogg", volume=0.45},
    audible_distance_modifier = 0.5,
    fade_in_ticks = 4,
    fade_out_ticks = 20,
  },
})
wreck.graphics_set.working_visualisations = nil

local wreck_frozen = merge(wreck, {
  name = "cerys-fulgoran-moon-garden-wreck-frozen",
})

data:extend({
  moon_garden,
  wreck,
  wreck_frozen
})
