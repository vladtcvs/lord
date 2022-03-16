local SL = minetest.get_translator("lord_inventory")

gui_bg_img = "background[5,5;1,1;gui_formbg.png;true]"
gui_slots = "listcolors[#606060AA;#606060;#141318;#30434C;#FFF]"

lord_inventory = {
	textures = {},
	main = {
		size = "size[8,8.5]",
		formspec = gui_bg_img
		..gui_slots
		.."image[0,0;1,1;lottarmor_helmet.png]"
		.."image[0,1;1,1;lottarmor_chestplate.png]"
		.."image[0,2;1,1;lottarmor_leggings.png]"
		.."image[0,3;1,1;lottarmor_boots.png]"
		.."image[3,0;1,1;lottarmor_helmet.png]"
		.."image[3,1;1,1;lottarmor_shirt.png]"
		.."image[3,2;1,1;lottarmor_trousers.png]"
		.."image[3,3;1,1;lottarmor_shoes.png]"
		.."image[4,0;1,1;lottarmor_cloak.png]"
		.."list[detached:player_name_armor;armor;0,0;1,4;]"
		.."list[detached:player_name_armor;armor;2,2;1,1;4]"
		.."list[detached:player_name_clothing;clothing;3,0;1,4;]"
		.."list[detached:player_name_clothing;clothing;4,0;1,1;4]"
		.."image[1.16,0.25;2,4;armor_preview]"
		.."image[2,2;1,1;lottarmor_shield.png]"
		.."list[current_player;main;0,4.25;8,1;]"
		.."list[current_player;main;0,5.5;8,3;8]"
		.."image[5.05,0;3.5,1;lottarmor_crafting.png]"
		.."list[current_player;craft;4,1;3,3;]"
		.."list[current_player;craftpreview;7,2;1,1;]"
		.."listring[current_player;main]"
		.."listring[current_player;craft]"
		.."image[7,3;1,1;lottarmor_trash.png]"
		.."list[detached:armor_trash;main;7,3;1,1;]"
		.."image_button[7,1;1,1;bags.png;bags;]",
	},
	bags = {
		size = "size[8,8.5]",
		formspec = "list[current_player;main;0,3.5;8,4;]"
		.."button[0,0;2,0.5;main;"..SL("Back").."]"
		.."button[0,2;2,0.5;bag1;"..SL("Bag").." 1]"
		.."button[2,2;2,0.5;bag2;"..SL("Bag").." 2]"
		.."button[4,2;2,0.5;bag3;"..SL("Bag").." 3]"
		.."button[6,2;2,0.5;bag4;"..SL("Bag").." 4]"
		.."list[detached:playername_bags;bag1;0.5,1;1,1;]"
		.."list[detached:playername_bags;bag2;2.5,1;1,1;]"
		.."list[detached:playername_bags;bag3;4.5,1;1,1;]"
		.."list[detached:playername_bags;bag4;6.5,1;1,1;]"
		.."background[5,5;1,1;gui_formbg.png;true]",
	},
	bag = {
		size = "size[8,8.5]",
		formspec = "list[current_player;main;0,4.5;8,4;]"
		.."button[0,0;2,0.5;main;"..SL("Main").."]"
		.."button[2,0;2,0.5;bags;"..SL("Bags").."]"
		.."image[7,0;1,1;image_bagimage]"
		.."list[current_player;bag_bagid_contents;0,1;8,3;]"
		.."listring[current_player;bag_bagid_contents]"
		.."listring[current_player;main]"
		.."background[5,5;1,1;gui_formbg.png;true]"
	}
}

local function get_main_formspec(name)
	if not lord_inventory.textures[name] then
		minetest.log("error", "lottarmor: Player texture["..name.."] is nil [get_main_formspec]")
		return ""
	end
	if not armor.def[name] then
		minetest.log("error", "lottarmor: Armor def["..name.."] is nil [get_main_formspec]")
		return ""
	end

	print("PREVIEW = "..lord_inventory.textures[name].preview)

	local formspec = lord_inventory.main.formspec:gsub("player_name", name)
	formspec = formspec:gsub("armor_preview", lord_inventory.textures[name].preview)
	formspec = formspec:gsub("armor_level", tostring(armor.def[name].level))
	formspec = formspec:gsub("armor_heal", tostring(armor.def[name].heal))
	formspec = formspec:gsub("armor_fire", tostring(armor.def[name].fire))
	return formspec
end

sfinv.register_page("lord_inventory:main", {
	title = SL("Inventory"),
	mainpage = true,
	get = function(self, player, context)
		local name = armor:get_valid_player(player, "[set_player_armor]")
		if not name then
			return sfinv.make_formspec(player, context, "", false, armor.size)
		end

		local content = get_main_formspec(name)
		return sfinv.make_formspec(player, context, content, false, armor.size)
	end,
	is_in_nav = function(self, player, context)
		return true
	end,
	on_player_receive_fields = function(self, player, context, fields)
		if fields.bags then
			sfinv.set_page(player, "lord_inventory:bags")
		end
	end,
})

races.register_init_callback(function(name, race, gender, skin, texture, face)
	local player = minetest.get_player_by_name(name)
	local player_inv = player:get_inventory()
	--Bags
	local bags_inv = minetest.create_detached_inventory(name.."_bags",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			player:get_inventory():set_size(listname.."contents", stack:get_definition().groups.bagslots)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
		end,
		allow_put = function(inv, listname, index, stack, player)
			if stack:get_definition().groups.bagslots then
				return 1
			else
				return 0
			end
		end,
		allow_take = function(inv, listname, index, stack, player)
			if player:get_inventory():is_empty(listname.."contents")==true then
				return stack:get_count()
			else
				return 0
			end
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
	}, name)
	for i=1,4 do
		local bag = "bag"..i
		player_inv:set_size(bag, 1)
		bags_inv:set_size(bag, 1)
		bags_inv:set_stack(bag,1,player_inv:get_stack(bag,1))
	end

	lord_inventory.textures[name] = {
		armor = "lottarmor_trans.png",
		preview = "character_preview.png"
	}
end)


armor:register_armor_changed_handler(function(player)
	print("ARMOR CHANGED")

	local name = player:get_player_name()
	local preview = multiskin:get_preview(name) or "character_preview.png"
	local player_armor = armor:build_armor(player)
	local name = player_armor.name

	lord_inventory.textures[name] = {}
	lord_inventory.textures[name].preview = preview
	lord_inventory.textures[name].armor = preview.."^"..(player_armor.texture)
	sfinv.invalidate_page(player, "lord_inventory:main")
end)

sfinv.register_page("lord_inventory:bags", {
	title = SL("Bags"),
	get = function(self, player, context)
		local name = player:get_player_name()
		local content = lord_inventory.bags.formspec
		content:gsub("playername", name)
		return sfinv.make_formspec(player, context, content, false, lord_inventory.bags.size)
	end,
	is_in_nav = function(self, player, context)
		return false
	end,
	on_player_receive_fields = function(self, player, context, fields)
		if fields.main then
			sfinv.set_page(player, "lord_inventory:main")
			return
		end

		for i=1,4 do
			local page = "bag"..i
			if fields[page] then
				if not (player:get_inventory():get_stack(page, 1):get_definition().groups.bagslots==nil) then
					sfinv.set_page(player, "lord_inventory:bag"..i)
					return
				end
			end
		end
	end,
})

for i=1,4 do
	sfinv.register_page("lord_inventory:bag"..i, {
		title = SL("Bag"..i),
		get = function(self, player, context)
			local image = player:get_inventory():get_stack("bag"..i, 1):get_definition().inventory_image
			local content = lord_inventory.bag.formspec
			content:gsub("bagimage", image)
			content:gsub("bagid", i)
			return sfinv.make_formspec(player, context, content, false, lord_inventory.bag.size)
		end,
		is_in_nav = function(self, player, context)
			return false
		end,
		on_player_receive_fields = function(self, player, context, fields)
			if fields.main then
				sfinv.set_page(player, "lord_inventory:main")
				return
			end

			if fields.bags then
				sfinv.set_page(player, "lord_inventory:bags")
				return
			end
		end,
	})
end
