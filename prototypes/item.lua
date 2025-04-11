data:extend({
  {
    -- Non-obtainable. It's here to make non-minable entities trigger a 'this entity cannot be mind' text when mined, without showing anything unusual in Factoriopedia.
    type = "item",
    name = "cerys-fulgoran-moon-garden",
    icon = "__cerys-lunaponics__/graphics/icons/moon-garden.png",
    subgroup = "production-machine",
    order = "h[moon-garden]-b[fulgoran-moon-garden]",
    hidden = true,
    default_import_location = "cerys",
    stack_size = 10,
    weight = 1000*kg
  },
})
