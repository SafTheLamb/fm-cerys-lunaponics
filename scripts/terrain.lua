local simplex_noise = require("__Cerys-Moon-of-Fulgora__.scripts.simplex_noise").d2
local common = require("__Cerys-Moon-of-Fulgora__.common")

local moon_garden = require("scripts.moon-garden")

local Public = {}

local function final_region(x, y)
	return -(((y / 64) ^ 2) + (30 - x) / 32)
end

--== Entity positions ==--

local tower_separation = 22
local max_radius = common.CERYS_RADIUS * 1.2

local hex_width = tower_separation
local hex_height = tower_separation * math.sqrt(3)
local col_offset = hex_width * 3 / 4 -- Horizontal distance between columns
local row_offset = hex_height / 2 -- Vertical offset for every other column

local max_cols = math.ceil(2 * max_radius / col_offset)
local max_rows = math.ceil(2 * max_radius / hex_height)

local function hex_grid_positions(args)
	local seed = args.seed
	local avoid_final_region = args.avoid_final_region or false
	local grid_scale = args.grid_scale or 1
	local noise_size = args.noise_size or 40
	local noise_scale = args.noise_scale or 500
	local displacement = args.displacement or { x = 0, y = 0 }

	local positions = {}
	for col = -max_cols, max_cols do
		for row = -max_rows, max_rows do
			local x = col * col_offset + displacement.x
			local y = row * hex_height + (col % 2) * row_offset + displacement.y

			local place = true
			if x ^ 2 + y ^ 2 > max_radius * max_radius then
				place = false
			end
			if x == 0 and y == 0 then
				place = false
			end
			if avoid_final_region and final_region(x, y) > 0 then
				place = false
			end

			if place then
				local noise_x = simplex_noise(x / noise_scale, y / noise_scale, seed + 100)
				local noise_y = simplex_noise(x / noise_scale, y / noise_scale, seed + 200)

				local p = {
					x = math.ceil(grid_scale * (x + noise_x * noise_size)),
					y = math.ceil(grid_scale * (y + noise_y * noise_size)),
				}

				table.insert(positions, p)
			end
		end
	end
	return positions
end

local moon_garden_positions = hex_grid_positions({
	seed = 3899, -- seed = 3901, --3905,
	grid_scale = 3.7,
	avoid_final_region = false,
	noise_size = 16,
	noise_scale = 150,
})

function Public.on_cerys_chunk_generated(event, surface)
  local area = event.area

  Public.create_moon_gardens(surface, area)
end

function Public.create_moon_gardens(surface, area)
	for _, p in ipairs(moon_garden_positions) do
		if
			p.x >= area.left_top.x
			and p.x < area.right_bottom.x
			and p.y >= area.left_top.y
			and p.y < area.right_bottom.y
		then
			local p2 = { x = p.x + 0.5, y = p.y + 0.5 }

			local colliding_simple_entities = surface.find_entities_filtered({
				type = "simple-entity",
				area = {
					left_top = { x = p2.x - 3.5, y = p2.y - 3.5 },
					right_bottom = { x = p2.x + 3.5, y = p2.y + 3.5 },
				},
			})
			for _, entity in ipairs(colliding_simple_entities) do
				entity.destroy()
			end

			local p3 = surface.find_non_colliding_position("cerys-fulgoran-moon-garden-wreck-frozen", p2, 5, 1)

			if p3 then
				Public.ensure_solid_foundation(surface, p3, 3, 3)

				local e = surface.create_entity({
					name = "cerys-fulgoran-moon-garden-wreck-frozen",
					position = p3,
					force = "player",
				})

				if e and e.valid then
					e.minable_flag = false
					e.destructible = false
					moon_garden.register_ancient_moon_garden(e, true)
				end
			end
		end
	end
end

function Public.ensure_solid_foundation(surface, center, width, height)
	local tiles = {}
	for dx = -width, width do
		for dy = -height, height do
			local tile_underneath = surface.get_tile(center.x + dx, center.y + dy)
			local tile_underneath_is_water = tile_underneath and tile_underneath.name == "cerys-dry-ice-on-water"

			if tile_underneath_is_water then
				table.insert(tiles, {
					name = "cerys-concrete",
					position = { x = math.floor(center.x) + dx, y = math.floor(center.y) + dy },
				})
			end
		end
	end
	surface.set_tiles(tiles, true)
end

return Public
