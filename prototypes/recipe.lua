data:extend({
  {
    type = "recipe",
    name = "cerys-repair-moon-garden",
    subgroup = "cerys-garden-repair",
    order = "b",
    icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png",
    energy_required = 1 / 4,
    enabled = false,
    hide_from_player_crafting = true,
    category = "moon-garden-repair",
    ingredients = {
      {type="item", name="ancient-structure-repair-part", amount=1},
      {type="item", name="processing-unit", amount=1},
    },
    results = {},
    allow_quality = false,
    allow_productivity = true,
    hide_from_signal_gui = true,
  },
  {
    type = "recipe",
    name = "cerys-upgrade-fulgoran-moon-garden-quality",
    subgroup = "cerys-garden-repair",
    enabled = false,
    order = "g",
    icon = "__cerys-lunaponics__/graphics/icons/moon-garden.png",
    energy_required = 30,
    hide_from_player_crafting = true,
    category = "fulgoran-lunaponics",
    ingredients = {
      {type="item", name="ancient-structure-repair-part", amount=10},
      {type="item", name="processing-unit", amount=10},
    },
    results = {},
    allow_quality = true,
    allow_productivity = false,
    hide_from_signal_gui = true,
  },
  {
    type = "recipe",
    name = "cerys-liquid-fertilizer",
    icon = "__cerys-lunaponics__/graphics/icons/fluid/cerys-liquid-fertilizer.png",
    category = "chemistry-or-cryogenics-or-fulgoran-cryogenics",
    subgroup = "cerys-processes",
    order = "d-b",
    surface_conditions = {
      {property="magnetic-field", min=120, max=120},
      {property="pressure", min=5, max=5},
    },
    energy_required = 2,
    enabled = false,
    auto_recycle = false,
    allow_productivity = true,
    ingredients = {
      {type="item", name="cerys-nitrogen-rich-minerals", amount=1},
      {type="fluid", name="ammonia", amount=10},
      {type="fluid", name="methane", amount=30}
    },
    results = {
      {type="fluid", name="liquid-fertilizer", amount=40}
    }
  }
})

if mods["bztin"] then
  data:extend({
    {
      type = "recipe",
      name = "alternative-nitrogen-rich-mineral-processing",
      always_show_made_in = true,
      icon = "__cerys-lunaponics__/graphics/icons/alternative-nitrogen-rich-mineral-processing.png",
      category = "fulgoran-cryogenics",
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type="item", name="cerys-nitrogen-rich-minerals", amount=1},
        {type="fluid", name="nitric-acid", amount=40},
        {type="fluid", name="water", amount=40},
      },
      results = {
        {type="item", name="tin-ore", amount=1},
        {type="fluid", name="fluorine", amount=50},
      },
      allow_productivity = true,
      subgroup = "cerys-processes",
      order = "d-b",
      auto_recycle = false,
      crafting_machine_tint = {
        primary = {r = 0.365, g = 0.815, b = 0.734, a = 1.000}, -- #5dcf55ff
        secondary = {r = 0.365, g = 0.694, b = 0.894, a = 1.000}, -- #c46464ff
      },
    },
  })
end
