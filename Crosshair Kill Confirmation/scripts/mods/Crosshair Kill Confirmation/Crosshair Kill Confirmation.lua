local mod = get_mod("Crosshair Kill Confirmation")

local unit_types = {
    "normal",
    "special",
    "elite",
    "boss"
}
local opacities = {}
local sizes = {}
local crosshairs = {}
local colors = {}
for i=1, #unit_types, 1 do
    unit_type = unit_types[i]
    opacities[unit_type] = 0
    sizes[unit_type] = 0
    crosshairs[unit_type] = "dot"
    colors[unit_type] = {255, 7, 7}
end

local duration = 0
local min_s = 0
local max_s = 0
local assists = {}
mod.gui = nil


--[[
    Functions
--]]

mod.change_setting = function(self)
    mod:destroy_gui()
end

mod.create_gui = function(self)
    if Managers.world:world("top_ingame_view") then
        local top_world = Managers.world:world("top_ingame_view")

        -- Create a screen overlay with specific materials we want to render
        mod.gui = World.create_screen_gui(top_world, "immediate",
            "material", "materials/Crosshair Kill Confirmation/icons"
        )

        -- Fetch mod settings
        for i=1, #unit_types, 1 do
            unit_type = unit_types[i]
            crosshairs[unit_type] = mod:get("crosshair_"..unit_type)
        end
        duration = mod:get("duration")
        min_s = mod:get("size")
        max_s = min_s * mod:get("pop")
    end
end

mod.destroy_gui = function(self)
    if Managers.world:world("top_ingame_view") then
        local top_world = Managers.world:world("top_ingame_view")
        if mod.gui then
            World.destroy_gui(top_world, mod.gui)
        end
        mod.gui = nil
    end
end

mod.unit_category = function(unit)
    local breed_categories = {}

    breed_categories["skaven_clan_rat"] = "normal"
    breed_categories["skaven_clan_rat_with_shield"] = "normal"
    breed_categories["skaven_dummy_clan_rat"] = "normal"
    breed_categories["skaven_slave"] = "normal"
    breed_categories["skaven_dummy_slave"] = "normal"
    breed_categories["chaos_marauder"] = "normal"
    breed_categories["chaos_marauder_with_shield"] = "normal"
    breed_categories["chaos_fanatic"] = "normal"
    breed_categories["critter_rat"] = "normal"
    breed_categories["critter_pig"] = "normal"

    breed_categories["skaven_gutter_runner"] = "special"
    breed_categories["skaven_pack_master"] = "special"
    breed_categories["skaven_ratling_gunner"] = "special"
    breed_categories["skaven_poison_wind_globadier"] = "special"
    breed_categories["chaos_vortex_sorcerer"] = "special"
    breed_categories["chaos_corruptor_sorcerer"] = "special"
    breed_categories["skaven_warpfire_thrower"] = "special"
    breed_categories["skaven_loot_rat"] = "special"
    breed_categories["chaos_tentacle"] = "special"
    breed_categories["chaos_tentacle_sorcerer"] = "special"
    breed_categories["chaos_plague_sorcerer"] = "special"
    breed_categories["chaos_plague_wave_spawner"] = "special"
    breed_categories["chaos_vortex"] = "special"
    breed_categories["chaos_dummy_sorcerer"] = "special"

    breed_categories["skaven_storm_vermin"] = "elite"
    breed_categories["skaven_storm_vermin_commander"] = "elite"
    breed_categories["skaven_storm_vermin_with_shield"] = "elite"
    breed_categories["skaven_plague_monk"] = "elite"
    breed_categories["chaos_berzerker"] = "elite"
    breed_categories["chaos_raider"] = "elite"
    breed_categories["chaos_warrior"] = "elite"
    
    breed_categories["skaven_rat_ogre"] = "boss"
    breed_categories["skaven_stormfiend"] = "boss"
    breed_categories["skaven_storm_vermin_warlord"] = "boss"
    breed_categories["skaven_stormfiend_boss"] = "boss"
    breed_categories["skaven_grey_seer"] = "boss"
    breed_categories["chaos_troll"] = "boss"
    breed_categories["chaos_dummy_troll"] = "boss"
    breed_categories["chaos_spawn"] = "boss"
    breed_categories["chaos_exalted_champion"] = "boss"
    breed_categories["chaos_exalted_champion_warcamp"] = "boss"
    breed_categories["chaos_exalted_sorcerer"] = "boss"

    local breed_data = Unit.get_data(unit, "breed")
    breed_name = breed_data.name
    if breed_categories[breed_name] then
        return breed_categories[breed_name]
    else
        -- Handle unknown breeds: everything below 300 HP is normal, above is a boss
        local health_extension = ScriptUnit.extension(unit, "health_system")
        local hp = health_extension:get_max_health()
        if hp > 300 then
            return "boss"
        else
            return "normal"
        end
    end
end

mod.interp_opacity = function(opacity)
    -- Modify opacity to have exponetial falloff
    return math.floor(math.pow(opacity/255,2)*255)
end

mod.interp_size = function(size)
    -- Modify size to have exponetial falloff
    return math.min(max_s, (math.pow(size, 0.5)*(max_s-min_s))+min_s)
end


--[[
    Hooks
--]]
mod:hook(GenericHitReactionExtension, "_execute_effect", function(func, self, unit, effect_template, biggest_hit, parameters, ...)
    local death_ext = self.death_extension
    local death_has_started = death_ext and death_ext.death_has_started
    local killing_blow = parameters.death and death_ext and not death_has_started

    local attacker_unit = biggest_hit[DamageDataIndex.ATTACKER]
    local damage_amount = biggest_hit[DamageDataIndex.DAMAGE_AMOUNT]

    mod:pcall(function()
        local local_player = Managers.player:local_player()
        local player_unit = local_player.player_unit
        local network_manager = Managers.state.network
        local unit_id, is_level_unit = network_manager:game_object_or_level_id(unit)

        if DamageUtils.is_player_unit(attacker_unit) and damage_amount > 0 then
            if (not killing_blow) and attacker_unit == player_unit then
                assists[unit_id] = 1
            elseif killing_blow and (attacker_unit == player_unit or assists[unit_id]) then
                local unit_type = mod.unit_category(unit)
                opacities[unit_type] = 255
                sizes[unit_type] = 0
                colors[unit_type] = {255, 25, 25}
                
                if assists[unit_id] then
                    if attacker_unit ~= player_unit then
                        colors[unit_type] = {7, 150, 210}
                    end
                    assists[unit_id] = nil  -- Remove from table
                    -- TODO clear assists periodically as units can die from other causes
                    -- TODO show assists from non-player causes (e.g. gunner fire, barrel explosions...)
                end
            end
        end
    end)

    func(self, unit, effect_template, biggest_hit, parameters, ...)
end)

mod:hook_safe(StateInGameRunning, "on_exit", function(...)
    -- Flush table for new mission
    assists = {}
end)

mod:hook_safe(CrosshairUI, "update_hit_markers", function(self, dt)
    if not mod.gui and Managers.world:world("top_ingame_view") then
        mod:create_gui()
    end
    for i=1, #unit_types, 1 do
        unit_type = unit_types[i]
        opacities[unit_type] = math.max(0, opacities[unit_type] - (dt/duration)*255)
        interp_opacity = mod.interp_opacity(opacities[unit_type])
        if unit_type == "normal" then
            interp_size = min_s*0.79  -- no animation for normal enemies
        else
            sizes[unit_type] = sizes[unit_type] + (dt/duration)
            interp_size = mod.interp_size(sizes[unit_type])
        end
        local icon_size = math.floor(interp_size * RESOLUTION_LOOKUP.scale)
        local icon_x = math.floor(RESOLUTION_LOOKUP.res_w/2 - icon_size/2)  -- Center icon
        local icon_y = math.floor(RESOLUTION_LOOKUP.res_h/2 - icon_size/2)  -- Center icon
        Gui.bitmap(mod.gui, crosshairs[unit_type], Vector2(icon_x, icon_y), Vector2(icon_size, icon_size), Color(interp_opacity,colors[unit_type][1],colors[unit_type][2],colors[unit_type][3]))
    end
end)


--[[
    Callback
--]]

mod.on_unload = function(exit_game)
    if mod.gui and Managers.world:world("top_ingame_view") then
        mod:destroy_gui()
    end
    return
end

mod.on_setting_changed = function(is_first_call)
    mod.change_setting()
end
