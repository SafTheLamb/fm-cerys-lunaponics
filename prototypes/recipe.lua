local wood_amount = mods["early-agriculture"] and settings.startup["early-agriculture-buff-tree-plant"].value and 6 or 4
local lunaponics_subgroup = mods["bioprocessing-tab"] and "astroponic-processes" or "fluid-recipes"

data:extend({
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
      {type="item", name="ancient-structure-repair-part", amount=1},
      {type="item", name="processing-unit", amount=5},
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
    category = "chemistry-or-cryogenics",
    additional_categories = {"fulgoran-cryogenics"},
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
    allow_decomposition = false,
    ingredients = {
      {type="item", name="cerys-nitrogen-rich-minerals", amount=1},
      {type="fluid", name="ammonia", amount=10},
      {type="fluid", name="methane", amount=30}
    },
    results = {
      {type="fluid", name="liquid-fertilizer", amount=40}
    }
  },
  {
    type = "recipe",
    name = "cerys-crude-lunaponics",
    always_show_made_in = true,
    icons = {
      {icon="__base__/graphics/icons/wood.png"},
      {icon="__base__/graphics/icons/fluid/water.png", shift={-10,-10}, scale=0.3},
      {icon="__Cerys-Moon-of-Fulgora__/graphics/icons/nitrogen-rich-minerals.png", shift={10,-10}, scale=0.3},
    },
    category = "fulgoran-lunaponics",
    subgroup = lunaponics_subgroup,
    order = "b[agriculture]-a[wood]-C[cerys]-b[crude-lunaponics]",
    enabled = false,
    allow_productivity = false,
    allow_decomposition = false,
    auto_recycle = false,
    energy_required = 18,
    ingredients = {
      {type="item", name="tree-seed", amount=1},
      {type="item", name="cerys-nitrogen-rich-minerals", amount=2},
      {type="fluid", name="water", amount=1000}
    },
    results = {
      {type="item", name="wood", amount=wood_amount},
      {type="fluid", name="methane", amount=50, show_details_in_recipe_tooltip=false}
    },
    main_product = "wood"
  },
  {
    type = "recipe",
    name = "cerys-tree-seed-synthesis",
    always_show_made_in = true,
    icons = {
      {icon="__Cerys-Moon-of-Fulgora__/graphics/icons/nuclear/nuclear-scrap.png"},
      {icon="__base__/graphics/icons/arrows/signal-clockwise-circle-arrow.png", tint={r=0.8, g=0.6, b=0.0, a=0.1}, scale=0.6, draw_background=false},
      {icon="__space-age__/graphics/icons/tree-seed.png", draw_background=true},
    },
    category = "fulgoran-lunaponics",
    subgroup = lunaponics_subgroup,
    order = "b[agriculture]-a[wood]-C[cerys]-a[tree-seed-from-nothing]",
    enabled = false,
    allow_productivity = false,
    allow_decomposition = false,
    auto_recycle = false,
    energy_required = 60,
    ingredients = {
      {type="item", name="cerys-nuclear-scrap", amount=100},
      {type="item", name="cerys-nitrogen-rich-minerals", amount=10},
      {type="item", name="methane-ice", amount=50},
      {type="fluid", name="water", amount=1000}
    },
    results = {
      {type="item", name="tree-seed", amount=1},
      {type="fluid", name="methane", amount=50, show_details_in_recipe_tooltip=false}
    },
    main_product = "tree-seed"
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
      allow_productivity = true,
      allow_decomposition = false,
      auto_recycle = false,
      ingredients = {
        {type="item", name="cerys-nitrogen-rich-minerals", amount=1},
        {type="fluid", name="cerys-nitric-acid", amount=40},
        {type="fluid", name="water", amount=40},
      },
      results = {
        {type="item", name="tin-ore", amount=1},
        {type="fluid", name="fluorine", amount=50},
      },
      subgroup = "cerys-processes",
      order = "d-b",
      crafting_machine_tint = {
        primary = {r = 0.365, g = 0.815, b = 0.734, a = 1.000}, -- #5dcf55ff
        secondary = {r = 0.365, g = 0.694, b = 0.894, a = 1.000}, -- #c46464ff
      },
    },
  })
end
