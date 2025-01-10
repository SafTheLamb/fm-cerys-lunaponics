local moon_garden = require("scripts.moon-garden")

local Public = {}

script.on_event({
	defines.events.on_pre_surface_cleared,
	defines.events.on_pre_surface_deleted,
}, function(event)
	local surface_index = event.surface_index
	local surface = game.surfaces[surface_index]

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	storage.lunaponics = nil
end)

script.on_event(defines.events.on_tick, function(event)
  local tick = event.tick

  local surface = game.get_surface("cerys")
	if not (surface and surface.valid) then
		return
	end

  if storage.lunaponics then
    Public.lunaponics_tick(surface, tick)
  end
end)

function Public.lunaponics_tick(surface, tick)
  moon_garden.tick_1_check_garden_quality_upgrades(surface)

  if tick % 20 == 0 then
		moon_garden.tick_20_check_garden_quality_upgrades(surface)
		-- Ideally, match the tick interval of the repair recipes:
		moon_garden.tick_15_check_broken_moon_gardens(surface)
	end
end

return Public
