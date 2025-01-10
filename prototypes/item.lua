data:extend({
  {
    -- Non-obtainable. It's here to make non-minable entities trigger a 'this entity cannot be mind' text when mined, without showing anything unusual in Factoriopedia.
    type = "item",
    name = "cerys-fulgoran-moon-garden",
    icons = {
      {icon="__Krastorio2Assets__/icons/entities/greenhouse.png", tint={153,204,255}}
    },
    subgroup = "production-machine",
    order = "h[moon-garden]-b[fulgoran-moon-garden]",
    hidden = true,
    default_import_location = "cerys",
    weight = 1000 * 1000,
    stack_size = 10,
  },
})
