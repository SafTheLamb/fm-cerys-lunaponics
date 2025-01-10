local Public = {}

Public.GARDEN_WRECK_STAGE_ENUM = {
	frozen = 0,
	needs_repair = 1,
}

Public.FIRST_GARDEN_REPAIR_RECIPES_NEEDED = 50
Public.SECOND_GARDEN_REPAIR_RECIPES_NEEDED = 150
Public.DEFAULT_GARDEN_REPAIR_RECIPES_NEEDED = 200

function Public.tick_15_check_broken_moon_gardens(surface)
	if not storage.lunaponics.broken_moon_gardens then
		return
	end

	for unit_number, garden in pairs(storage.lunaponics.broken_moon_gardens) do
		local e = garden.entity

		if e and e.valid then
			local products_finished = e.products_finished

			local products_required = Public.DEFAULT_GARDEN_REPAIR_RECIPES_NEEDED

			if storage.lunaponics.first_unfrozen_moon_garden and storage.lunaponics.first_unfrozen_moon_garden == e.unit_number then
				products_required = Public.FIRST_GARDEN_REPAIR_RECIPES_NEEDED
			end
			if
				storage.lunaponics.second_unfrozen_moon_garden
				and storage.lunaponics.second_unfrozen_moon_garden == e.unit_number
			then
				products_required = Public.SECOND_GARDEN_REPAIR_RECIPES_NEEDED
			end

			if garden.stage == Public.GARDEN_WRECK_STAGE_ENUM.frozen then
				if not e.frozen and game.tick > garden.creation_tick + 300 then
					Public.unfreeze_moon_garden(surface, garden)
				end
			elseif products_finished >= products_required then
				if garden.rendering then
					if garden.rendering.valid then
						garden.rendering.destroy()
					end
					garden.rendering = nil
				end

				local e2 = surface.create_entity({
					name = "cerys-fulgoran-moon-garden",
					position = e.position,
					force = e.force,
					direction = e.direction,
					fast_replace = true,
				})

				if e2 and e2.valid then
					e2.minable_flag = false
					e2.destructible = false
				end

				if e and e.valid then
					local module_inv = e.get_module_inventory()
					local module_inv2 = e2.get_module_inventory()
					if module_inv and module_inv.valid and module_inv2 and module_inv2.valid then
						local contents = module_inv.get_contents()
						for _, m in pairs(contents) do
							module_inv2.insert({ name = m.name, count = m.count, quality = m.quality })
						end
					end

					e.destroy()
				end

				storage.lunaponics.broken_moon_gardens[unit_number] = nil
			elseif products_finished > 0 or e.is_crafting() then
				if not storage.lunaponics.first_unfrozen_moon_garden then
					storage.lunaponics.first_unfrozen_moon_garden = e.unit_number
				end
				if
					not storage.lunaponics.second_unfrozen_moon_garden
					and (
						storage.lunaponics.first_unfrozen_moon_garden
						and e.unit_number ~= storage.lunaponics.first_unfrozen_moon_garden
					)
				then
					storage.lunaponics.second_unfrozen_moon_garden = e.unit_number
				end

				if not garden.rendering then
					garden.rendering = rendering.draw_text({
						text = "",
						surface = surface,
						target = {
							entity = e,
							offset = { 0, -3.8 },
						},
						color = { 0, 255, 0 },
						scale = 1.2,
						font = "default-game",
						alignment = "center",
						use_rich_text = true,
					})
				end

				local repair_parts = 0

				if e and e.valid then
					local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
					if input_inv and input_inv.valid then
						repair_parts = input_inv.get_item_count("ancient-structure-repair-part")
					end
				end

				local repair_parts_count = products_finished + (e.is_crafting() and 1 or 0) + repair_parts

				garden.rendering.color = repair_parts_count >= products_required and { 0, 255, 0 } or { 255, 200, 0 }
				garden.rendering.text = {
					"cerys.repair-remaining-description",
					"[item=ancient-structure-repair-part]",
					repair_parts_count,
					products_required,
				}
			end
		else
			storage.lunaponics.broken_moon_gardens[unit_number] = nil
		end
	end
end

Public.register_ancient_moon_garden = function(entity, frozen)
	if not (entity and entity.valid) then
		return
	end

	storage.lunaponics.broken_moon_gardens[entity.unit_number] = {
		entity = entity,
		stage = frozen and Public.GARDEN_WRECK_STAGE_ENUM.frozen or Public.GARDEN_WRECK_STAGE_ENUM.needs_repair,
		creation_tick = game.tick,
	}
end

function Public.unfreeze_moon_garden(surface, garden)
	local e = garden.entity

	if not (e and e.valid) then
		return
	end

	local input_inv = e.get_inventory(defines.inventory.assembling_machine_input)
	local contents = nil
	if input_inv and input_inv.valid then
		contents = input_inv.get_contents()

		if #contents > 0 then
			-- Kick any players out of the GUI. A craft is about to complete, and we want them to notice the sign above the moon garden.
			for _, player in pairs(game.connected_players) do
				if player.opened and player.opened == e then
					player.opened = nil
				end
			end
		end
	end

	local e2 = surface.create_entity({
		name = "cerys-fulgoran-moon-garden-wreck",
		position = e.position,
		force = e.force,
		fast_replace = true,
	})

	if e2 and e2.valid then
		e2.minable_flag = false
		e2.destructible = false

		if e and e.valid and input_inv and input_inv.valid then
			local input_inv2 = e2.get_inventory(defines.inventory.assembling_machine_input)
			if input_inv2 and input_inv2.valid then
				for _, c in pairs(contents) do
					local new_count = c.count + 1 -- one will have been consumed when the garden started crafting. WARNING: If the recipe changes to have >1 count for ingredient, this will break.
					input_inv2.insert({ name = c.name, count = new_count, quality = c.quality })
				end
			end

			local module_inv = e.get_inventory(defines.inventory.assembling_machine_modules)
			local module_inv2 = e2.get_inventory(defines.inventory.assembling_machine_modules)
			if module_inv and module_inv.valid and module_inv2 and module_inv2.valid then
				local contents2 = module_inv.get_contents()
				for _, c in pairs(contents2) do
					module_inv2.insert({ name = c.name, count = c.count, quality = c.quality })
				end
			end

			if e and e.valid then
				e.destroy()
			end
		end

		garden.entity = e2
	end

	garden.stage = Public.GARDEN_WRECK_STAGE_ENUM.needs_repair
end

local CRAFTING_PROGRESS_THRESHOLD = 0.97 -- Since there's no API for completing a craft, we need to watch for recipes above this threshold

function Public.tick_20_check_garden_quality_upgrades(surface)
	storage.lunaponics.garden_upgrade_monitor = storage.lunaponics.garden_upgrade_monitor or {}

	local gardens = surface.find_entities_filtered({
		name = "cerys-fulgoran-moon-garden",
	})

	for _, garden in pairs(gardens) do
		if garden.valid and garden.is_crafting() then
			local recipe, recipe_quality = garden.get_recipe()
			if recipe and recipe.name == "cerys-upgrade-fulgoran-moon-garden-quality" then
				local garden_quality = garden.quality

				if garden_quality.next and garden_quality.next.name == recipe_quality.name then
					storage.lunaponics.garden_upgrade_monitor[garden.unit_number] = {
						entity = garden,
						quality_upgrading_to = recipe_quality.name,
					}
				else
					garden.set_recipe(nil)
					for _, ingredient in
						pairs(prototypes.recipe["cerys-upgrade-fulgoran-moon-garden-quality"].ingredients)
					do
						for _ = 1, ingredient.amount do
							surface.spill_item_stack({
								position = garden.position,
								stack = {
									name = ingredient.name,
									count = 1,
									quality = recipe_quality.name,
								},
							})
						end
					end
					garden.set_recipe(recipe, recipe_quality)
					storage.lunaponics.garden_upgrade_monitor[garden.unit_number] = nil
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
