local terrain = require("terrain")

local Public = {}

function Public.initialize_lunaponics(surface) -- Must run before terrain generation
	if storage.lunaponics and surface and surface.valid then
		return
	end

  Public.ensure_lunaponics_storage_and_tables()
end

script.on_init(function()
  local surface = game.get_surface("cerys")
	if surface then
		Public.initialize_lunaponics()
    local gardens = surface.find_entities_filtered{name={"cerys-fulgoran-moon-garden", "cerys-fulgoran-moon-garden-frozen"}}
    if not gardens or #gardens == 0 then
      for chunk in surface.get_chunks() do
        terrain.on_cerys_chunk_generated(chunk, surface)
      end
    end
    gardens = surface.find_entities_filtered{name="cerys-fulgoran-moon-garden", "cerys-fulgoran-moon-garden-frozen"}
    plants = surface.find_entities_filtered{name={"cerys-fulgoran-cryogenic-plant", "cerys-fulgoran-cryogenic-plant-wreck", "cerys-fulgoran-cryogenic-plant-wreck-frozen"}}
    if (not gardens or #gardens == 0) and (plants and #plants > 0) then
      game.print("ERROR: Cerys is already generated and Lunaponics was unable to generate any Moon gardens. You can place some (default is ~5) manually with the editor, though they will be minable by default, and you won't be able to upgrade their quality like intended.")
    end
  end
end)

script.on_event(defines.events.on_surface_created, function(event)
	local surface_index = event.surface_index
	local surface = game.surfaces[surface_index]

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	Public.initialize_lunaponics(surface)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	if not storage.lunaponics then
		-- Hold on tiger. You must have generated the surface in a non-standard way. Let's run this first:
		Public.initialize_lunaponics(surface)
	end

	terrain.on_cerys_chunk_generated(event, surface)
end)

function Public.ensure_lunaponics_storage_and_tables()
  if not storage.lunaponics then
    storage.lunaponics = {
      initialization_version = script.active_mods["cerys-lunaponics"],
    }
  end

  if not storage.lunaponics.frozen_moon_gardens then
    storage.lunaponics.frozen_moon_gardens = {}
  end
end
