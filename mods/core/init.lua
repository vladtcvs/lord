lord = {}

-- dofile()'s the file located in the mod directory
function lord.do_file(relative_path)
	local directory = minetest.get_modpath(minetest.get_current_modname())
	dofile(directory .. "/" .. relative_path)
end

-- A wrapper around intllib, so we don't have to write ugly expressions at
-- the top of each source file
function lord.translate()
	if minetest.global_exists("intllib") then
		return intllib.Getter()
	else
		return function(str) return str end
	end
end

-- Reports that mod was loaded
function lord.mod_loaded()
	if minetest.setting_getbool("msg_loading_mods") then
		minetest.log("action", minetest.get_current_modname() .. " mod loaded")
	end
end
