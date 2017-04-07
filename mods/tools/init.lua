tools = {}
tools.tool_types = {}

function tools.register_tool(name, tooldef)
	table.insert(tools.tool_types, name)
	tools[name] = tooldef
end

-- Load tables
lord.do_file("picks.lua")
lord.do_file("shovels.lua")
lord.do_file("axes.lua")
lord.do_file("swords.lua")
lord.do_file("battleaxes.lua")
lord.do_file("warhammers.lua")
lord.do_file("spears.lua")
lord.do_file("daggers.lua")
lord.do_file("special.lua")

-- Source materials
tools.sources = {
	wood = "group:wood",
	stone = "group:stone",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
	copper = "default:copper_ingot",
	tin = "lottores:tin_ingot",
	silver = "lottores:silver_ingot",
	gold = "default:gold_ingot",
	galvorn = "lottores:galvorn_ingot",
	mithril = "lottores:mithril_ingot",
}

local function get_capability(itemdef, cap)
	if itemdef[cap] == nil then
		return nil
	end
	return {
		times = itemdef[cap].times,
		uses = itemdef[cap].uses,
		maxlevel = itemdef[cap].maxlevel,
		maxwear = itemdef[cap].maxwear,
	}
end

local function register_tool(tool_type, material, itemdef)
	minetest.register_tool("tools:"..tool_type.."_"..material, {
		description = itemdef.description,
		inventory_image = "tools_"..tool_type.."_"..material..".png"..
			(itemdef.image_transform or ""),
		wield_image = "tools_"..tool_type.."_"..material..".png"..
			(itemdef.wield_image_transform or ""),
		range = itemdef.range,
		tool_capabilities = {
			full_punch_interval = itemdef.full_punch_interval,
			max_drop_level = itemdef.max_drop_level,
			groupcaps = {
				cracky = get_capability(itemdef, "cracky"),
				choppy = get_capability(itemdef, "choppy"),
				snappy = get_capability(itemdef, "snappy"),
				crumbly = get_capability(itemdef, "crumbly")
			},
			damage_groups = itemdef.damage_groups,
		},
		groups = itemdef.groups,
	})
end

local function register_craft(tool_type, material, itemdef)
	if tools.sources[material] == nil then
		minetest.log("error", "Cannot find source material for the craft recipe"..
			" (output='"..material.."')")
	end
	for _, r in pairs(tools[tool_type].get_recipes(tools.sources[material])) do
		minetest.register_craft({
			output = "tools:"..tool_type.."_"..material,
			recipe = r
		})
	end
end

for _, tool_type in ipairs(tools.tool_types) do
	for material, _ in pairs(tools[tool_type]) do
		local itemdef = tools[tool_type][material]
		if type(itemdef) == "table" then
			register_tool(tool_type, material, itemdef)
			register_craft(tool_type, material, itemdef)
		end
	end
end

lord.mod_loaded()
