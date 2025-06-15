local Public = {}

local CRAFTING_PROGRESS_THRESHOLD = 0.97 -- Since there's no API for completing a craft, we need to watch for recipes above this threshold

function Public.tick_15_check_frozen_moon_gardens(surface)
	if not storage.lunaponics.frozen_moon_gardens then
		return
	end

	for unit_number, garden in pairs(storage.lunaponics.frozen_moon_gardens) do
		local e = garden.entity
		if e and e.valid then
			if not e.frozen and game.tick > garden.creation_tick + 300 then
				Public.unfreeze_garden(surface, garden)
				storage.lunaponics.frozen_moon_gardens[unit_number] = nil
			end
		else
			storage.lunaponics.frozen_moon_gardens[unit_number] = nil
		end
	end
end

function Public.register_ancient_moon_garden(entity)
	if not (entity and entity.valid) then
		return
	end

	storage.lunaponics.frozen_moon_gardens[entity.unit_number] = {
		entity = entity,
		creation_tick = game.tick
	}
end

function Public.unfreeze_garden(surface, garden)
	local e = garden.entity
	if not (e and e.valid) then
		return
	end

	local e2 = surface.create_entity({
		name = "cerys-fulgoran-moon-garden",
		position = e.position,
		force = e.force,
		fast_replace = true
	})

	if e2 and e2.valid then
		e2.minable_flag = false
		e2.destructible = false

		e.destroy()
	end
end

function Public.tick_20_check_garden_quality_upgrades(surface)
	storage.lunaponics.garden_upgrade_monitor = storage.lunaponics.garden_upgrade_monitor or {}

	local gardens = surface.find_entities_filtered({
		name = "cerys-fulgoran-moon-garden",
	})

	for _, garden in pairs(gardens) do
    storage.lunaponics.garden_upgrade_monitor[garden.unit_number] = nil
    	if garden and garden.valid and garden.quality and garden.quality.next then
			local recipe, recipe_quality = garden.get_recipe()

			if recipe and recipe.name == "cerys-upgrade-fulgoran-moon-garden-quality" then
				if garden.quality.next and garden.quality.next.name == recipe_quality.name then
					storage.lunaponics.garden_upgrade_monitor[garden.unit_number] = {
						entity = garden,
						quality_upgrading_to = recipe_quality.name,
					}
				else
					local inv = garden.get_inventory(defines.inventory.crafter_input)

					if inv and inv.valid then
						local contents = inv.get_contents()
						for _, ingredient in pairs(contents) do
							inv.remove({
								name = ingredient.name,
								count = ingredient.count,
								quality = ingredient.quality,
							})

							surface.spill_item_stack({
								position = garden.position,
								stack = {
									name = ingredient.name,
									count = ingredient.count,
									quality = ingredient.quality,
								},
							})
						end
					end

					garden.set_recipe(recipe, garden.quality.next)
				end
			end
		end
	end
end

function Public.tick_1_check_garden_quality_upgrades(surface)
	if not (storage and storage.lunaponics and storage.lunaponics.garden_upgrade_monitor) then
		return
	end

	for unit_number, data in pairs(storage.lunaponics.garden_upgrade_monitor) do
		local e = data.entity
		local quality_upgrading_to = data.quality_upgrading_to

		if not (e and e.valid and e.is_crafting()) then
			storage.lunaponics.garden_upgrade_monitor[unit_number] = nil
		else
			local recipe, quality = e.get_recipe()
			local still_the_same_recipe = recipe
				and recipe.name == "cerys-upgrade-fulgoran-moon-garden-quality"
				and quality
				and quality.name == quality_upgrading_to

			if not still_the_same_recipe then
				storage.lunaponics.garden_upgrade_monitor[unit_number] = nil
			else
				if e.crafting_progress > CRAFTING_PROGRESS_THRESHOLD then
					local e2 = surface.create_entity({
						name = "cerys-fulgoran-moon-garden",
						position = e.position,
						force = e.force,
						direction = e.direction,
						fast_replace = true,
						quality = quality_upgrading_to,
					})

					if e and e.valid and e2 and e2.valid then
						e2.minable_flag = false
						e2.destructible = false

						e2.set_recipe(nil)

						local old_input = e.get_inventory(defines.inventory.assembling_machine_input)

						local input = old_input.get_contents()
						for _, m in pairs(input) do
							for _ = 1, m.count do
								surface.spill_item_stack({
									position = e.position,
									stack = { name = m.name, count = 1, quality = m.quality },
								})
							end
						end

						local old_modules = e.get_module_inventory()
						local new_modules = e2.get_module_inventory()

						local modules = old_modules.get_contents()
						for _, m in pairs(modules) do
							new_modules.insert({ name = m.name, count = m.count, quality = m.quality })
						end

						e.destroy()
					end

					storage.lunaponics.garden_upgrade_monitor[unit_number] = nil
				end
			end
		end
	end
end

return Public
