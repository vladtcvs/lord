throwing = {}

throwing.arrows = {}

local function node_ok(pos, fallback)
        fallback = fallback or "default:dirt"
        local node = minetest.get_node_or_nil(pos)
        if not node then
                return minetest.registered_nodes[fallback]
        end
        if minetest.registered_nodes[node.name] then
                return node
        end
        return minetest.registered_nodes[fallback]
end

function throwing:arrow_type(arrow_name)
	if throwing.arrows[arrow_name] ~= nil then
		return throwing.arrows[arrow_name].arrow_type or "none"
	else
		return "none"
	end
end

function throwing:shoot(owner, arrow_name, pos, dir, distance)
	local dl = (dir.x^2 + dir.y^2 + dir.z^2)^0.5;
	dir.x = dir.x / dl
	dir.y = dir.y / dl
	dir.z = dir.z / dl
	
	pos.x = pos.x + dir.x * distance
	pos.y = pos.y + dir.y * distance
	pos.z = pos.z + dir.z * distance

        local obj = minetest.add_entity(pos, arrow_name)

        local ent = obj:get_luaentity()
        if ent then
		local vec = {}
		local v = ent.velocity or 1 -- or set to default
		vec.x = v * dir.x
		vec.y = v * dir.y
		vec.z = v * dir.z
		ent.switch = 1
		ent.owner_id = tostring(owner) -- add unique owner id to arrow
		obj:setvelocity(vec)
	end
	return true
end

local function hit_node(pos, arrow, callback)
	local node = node_ok(pos).name
	if minetest.registered_nodes[node].walkable then
		callback(self, pos, node)
		if arrow.drop == true then
			pos.y = pos.y + 1
			arrow.lastpos = (arrow.lastpos or pos)
			minetest.add_item(arrow.lastpos, arrow.object:get_luaentity().name)
		end
		return true
	end
	return false
end

local function hit_player(player, arrow, callback, owner_id)	
	if player:get_player_name() ~= owner_id then
		callback(arrow, player)
		return true
	end
	return false
end

local function hit_mob(mob, arrow, callback, owner_id)	
	local entity = mob:get_luaentity() and mob:get_luaentity().name or ""

	if tostring(mob) ~= owner_id 
	   and entity ~= "__builtin:item"
	   and entity ~= "__builtin:falling_node"
	   and entity ~= "gauges:hp_bar"
	   and entity ~= "signs:text"
	   and entity ~= "itemframes:item" then
		callback(arrow, mob)
		return true
	end
	return false
end

local function arrow_step(self, dtime)
	self.timer = self.timer + 1

	local pos = self.object:getpos()

	if self.switch == 0
	   or self.timer > 150
	   or not within_limits(pos, 0) then
		self.object:remove() ; -- print ("removed arrow")
		return
	end

	-- does arrow have a tail (fireball)
	if self.definition.tail
	   and self.definition.tail == 1
	   and self.definition.tail_texture then
		minetest.add_particle({
			pos = pos,
			velocity = {x = 0, y = 0, z = 0},
			acceleration = {x = 0, y = 0, z = 0},
			expirationtime = self.definition.expire or 0.25,
			collisiondetection = false,
			texture = self.definition.tail_texture,
			size = self.definition.tail_size or 5,
			glow = self.definition.glow or 0,
		})
	end

	local res = false
	if self.hit_node then
		res = hit_node(pos, self, self.hit_node)
	end

	if res == false and (self.hit_player or self.hit_mob) then
		for _,player in pairs(minetest.get_objects_inside_radius(pos, 1.0)) do
			local itself = (player == self.object)
			if not itself and self.hit_player and player:is_player() then
				res = hit_player(player, self, self.hit_player, self.owner_id) or res
			end
			if not itself and self.hit_mob and not player:is_player() then
				res = hit_mob(player, self, self.hit_mob, self.owner_id) or res
			end
		end
	end

	if res == true then
		self.object:remove();
	end
	self.lastpos = pos
end


-- register arrow for shoot attack
function throwing:register_arrow(name, def)

	if not name or not def then return end -- errorcheck

	throwing.arrows[name] = def
	minetest.register_entity(name, {
		definition = def,
		physical = false,
		visual = def.visual,
		visual_size = def.visual_size,
		textures = def.textures,
		velocity = def.velocity,
		hit_player = def.hit_player,
		hit_node = def.hit_node,
		hit_mob = def.hit_mob,
		drop = def.drop or false, -- drops arrow as registered item when true
		collisionbox = {0, 0, 0, 0, 0, 0}, -- remove box around arrows
		timer = 0,
		switch = 0,
		owner_id = def.owner_id,
		rotate = def.rotate,
		automatic_face_movement_dir = def.rotate
			and (def.rotate - (pi / 180)) or false,

		on_step = def.on_step or arrow_step
	})
end

