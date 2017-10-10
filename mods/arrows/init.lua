local SL = lord.require_intllib()

arrows = {}

function arrows:register_arrow(name, definition)
	throwing:register_arrow(name, {
		visual = "sprite",
		visual_size = {x=1, y=1},
		textures = {definition.texture},
		velocity = 25,
		drop = true,
		arrow_type = definition.arrow_type,
		hit_player = function(self, player)
        	        local s = self.object:getpos()
                	local p = player:getpos()
	                local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
	                player:punch(self.object, 1.0,  {
	                        full_punch_interval=1.0,
	                        damage_groups = {fleshy=definition.damage},
	                }, vec)
		end,
		hit_mob = function(self, player)
	                local s = self.object:getpos()
	                local p = player:getpos()
	                local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
	                player:punch(self.object, 1.0,  {
	                        full_punch_interval=1.0,
	                        damage_groups = {fleshy=definition.damage},
	                }, vec)
		end,
		hit_node = function(self, pos, node)
		end
	})
end

-- Arrow nodebox
local arrow_node_box = {
	type = "fixed",
	fixed = {
		-- Shaft
		{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
		--Spitze
		{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
		{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
		--Federn
		{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
		{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
		{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
		{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},
		
		{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
		{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
		{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
		{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
	}
}


-- Steel arrow --

minetest.register_craftitem("arrows:arrow", {
	description = SL("Arrow"),
	inventory_image = "lottthrowing_arrow.png",
})

minetest.register_craft({
	output = 'arrows:arrow 16',
	recipe = {
		{'default:stick', 'default:stick', 'default:steel_ingot'},
	}
})

arrows:register_arrow("arrows:arrow", {damage = 2, texture = "lottthrowing_arrow.png", arrow_type = "arrow"})


-- Mithril arrow --
minetest.register_craftitem("arrows:arrow_mithril", {
	description = SL("Mithril Arrow"),
	inventory_image = "lottthrowing_arrow_mithril.png",
})

minetest.register_craft({
	output = 'arrows:arrow_mithril 16',
	recipe = {
		{'default:stick', 'default:stick', 'lottores:mithril_ingot'},
	}
})

arrows:register_arrow("arrows:arrow_mithril", {damage = 10, texture = "lottthrowing_arrow_mithril.png", arrow_type = "arrow"})


-- Bolt nodebox --
local bolt_node_box = {
	type = "fixed",
	fixed = {
		-- Shaft
		{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
		--Spitze
		{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
		{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
		--Federn
		{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
		{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
		{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
		{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},
		
		{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
		{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
		{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
		{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
	}
},

-- Steel bolt --

minetest.register_craftitem("arrows:bolt", {
	description = SL("Bolt"),
	inventory_image = "lottthrowing_bolt.png",
})

minetest.register_craft({
	output = 'arrows:bolt 16',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot'},
	}
})

arrows:register_arrow("arrows:bolt", {damage = 4, texture = "lottthrowing_bolt.png", arrow_type = "bolt"})

-- Mithril bolt --

minetest.register_craftitem("arrows:bolt_mithril", {
	description = SL("Mithril Bolt"),
	inventory_image = "lottthrowing_bolt_mithril.png",
})

minetest.register_craft({
	output = 'arrows:bolt_mithril 16',
	recipe = {
		{'default:steel_ingot', 'lottores:mithril_ingot'},
	}
})

arrows:register_arrow("arrows:bolt_mithril", {damage = 20, texture = "lottthrowing_bolt_mithril.png", arrow_type = "bolt"})

-- Mob Attacks

local flame_node = function(pos)
	local n = minetest.get_node(pos).name
	local fbd = minetest.registered_nodes[n].groups.forbidden
	if fbd == nil then
		if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
			minetest.set_node(pos, {name="fire:basic_flame"})
		else
			minetest.remove_node(pos)
		end
	end
end

local flame_area = function(p1, p2)
	local x
	local y
	local z
	for y=p1.y,p2.y do
	for z=p1.z,p2.z do
		minetest.punch_node({x=p1.x-1, y=y, z=z})
		minetest.punch_node({x=p2.x+1, y=y, z=z})
	end
	end

	for x=p1.x,p2.x do
	for z=p1.z,p2.z do
		minetest.punch_node({x=x, y=p1.y-1, z=z})
		minetest.punch_node({x=x, y=p2.y+1, z=z})
	end
	end

	for x=p1.x,p2.x do
	for y=p1.y,p2.y do
		minetest.punch_node({x=x, y=y, z=p1.z-1})
		minetest.punch_node({x=x, y=y, z=p2.z+1})
	end
	end

	for x=p1.x,p2.x do
		for y=p1.y,p2.y do
			for z=p1.z,p2.z do
				flame_node({x=x, y=y, z=z})
			end
		end
	end
end

throwing:register_arrow("arrows:darkball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"lottmobs_darkball.png"},
	velocity = 5,
	arrow_type = "magic",
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=4},
		}, vec)
		local pos = self.object:getpos()
		local p1 = {x=pos.x-1, y=pos.y-1, z=pos.z-1}
		local p2 = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
		flame_area(p1, p2)
	end,
	hit_mob = function(self, mob)
		local s = self.object:getpos()
		local p = mob:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		mob:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=4},
		}, vec)
		local pos = self.object:getpos()
		local p1 = {x=pos.x-1, y=pos.y-1, z=pos.z-1}
		local p2 = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
		flame_area(p1, p2)
	end,
	hit_node = function(self, pos, node)
		local p1 = {x=pos.x-1, y=pos.y-2, z=pos.z-1}
		local p2 = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
		flame_area(p1, p2)
	end
})

-- fireball (weapon)
throwing:register_arrow("arrows:fireball", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"mobs_fireball.png"},
	velocity = 6,
	arrow_type = "magic",
	tail = 1,
	tail_texture = "mobs_fireball.png",
	tail_size = 10,
	glow = 5,
	expire = 0.1,

	-- direct hit, no fire... just plenty of pain
	--hit_player = function(self, player)
		--player:punch(self.object, 1.0, {
	--		full_punch_interval = 1.0,
	--		damage_groups = {fleshy = 8},
	--	}, nil)
	--end,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=4},
		}, vec)
		local pos = self.object:getpos()
		local p1 = {x=pos.x-1, y=pos.y-1, z=pos.z-1}
		local p2 = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
		flame_area(p1, p2)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8},
		}, nil)
	end,

	-- node hit, bursts into flame
	--hit_node = function(self, pos, node)
	--	mobs:explosion(pos, 1, 1, 0)
	--end
	hit_node = function(self, pos, node)
		local p1 = {x=pos.x-1, y=pos.y-2, z=pos.z-1}
		local p2 = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
		flame_area(p1, p2)
	end
})

