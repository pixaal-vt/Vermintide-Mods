local mod = get_mod("Less Annoying Friendly Fire")

--[[ TODO
    Show damage number next to portait
    Damage threshold for green crosshair
    Make frame opacity directly affected by damage amount. Then no threshold is needed as it will become more opaque the more damage in a short period is done.
]]--

local state = {
    STARTING = 1,
    ONGOING = 2
}
local ignore_this_ff = {}

-- These are used to pass data to the widget draw function
local recent_damage_amount = 0
local recent_health = 100
local damage_is_from_self = false

local refresh_widget = false
local opacity_mult = 1
local duration_mult = 1
local max_opacity = 255
local min_opacity = 180

-- Damage types that don't show the indicator - copied from damage_indicator_gui.lua without modifications.
local ignored_damage_types = {
    temporary_health_degen = true,
    vomit_face = true,
    damage_over_time = true,
    buff = true,
    vomit_ground = true,
    heal = true,
    health_degen = true,
    warpfire_face = true,
    globadier_gas_dot = true,
    wounded_dot = true,
    buff_shared_medpack = true,
    knockdown_bleed = true,
    warpfire_ground = true
}

--[[
    Functions
--]]

mod.map_range = function (i,a,b,x,y)
    sab = b - a
    sxy = y - x
    i = (i - a) / sab
    i = x + (i * sxy)
    i = math.max(x, math.min(y, i))  -- Clamp
    return i
end

mod.nice_unit_name = function(u)
    local name = "unknown_unit"
    if DamageUtils.is_player_unit(u) then
        local owner = Managers.player:owner(u)
        local hero_name = owner:profile_display_name()
        local profile_index = owner:profile_index()
        local career_index = owner:career_index()
        name = SPProfiles[profile_index].careers[career_index].name
    else
        local breed = Unit.get_data(u, "breed")
        name  = breed and breed.name
    end
    return name
end

mod.debug_print = function(s)
    if (mod:get("debug")) then
        mod:echo(s)
    end
end


--[[
    Hooks
--]]

mod:hook(DamageIndicatorGui, "update", function(func, self, dt)
    -- Hide the damage indicator arrow sometimes

    local peer_id = self.peer_id
    local my_player = self.player_manager:player_from_peer_id(peer_id)
    local player_unit = my_player.player_unit

    local damage_info
    local saved_attackers = {}

    if player_unit then
        -- Check recent damages for FF.
        local health_extension = ScriptUnit.extension(player_unit, "health_system")
        local array_length = 0
        damage_info, array_length = health_extension:recent_damages()

        if array_length > 0 then
            for i = 1, array_length / DamageDataIndex.STRIDE, 1 do
                local index = (i - 1) * DamageDataIndex.STRIDE
                local index_with_offset = index + DamageDataIndex.ATTACKER
                local attacker = damage_info[index_with_offset]
                local damage_amount = damage_info[DamageDataIndex.DAMAGE_AMOUNT]

                if damage_amount >= 0 then  -- Ignore damage with negative amounts, not sure what that is, maybe natural bond?
                    mod:pcall(function ()
                        if damage_info[DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "temporary_health_degen" then
                            mod.debug_print("DMG: " .. tostring(damage_amount) .. " (" .. damage_info[DamageDataIndex.DAMAGE_SOURCE_NAME] .. ") " .. (mod.nice_unit_name(attacker) or "nil"))
                        end
                        return 
                    end)

                    local was_pushed = false
                    if mod:get("hide_pushes") and damage_amount == 0 and (not DamageUtils.is_player_unit(attacker)) then
                        was_pushed = true
                    end

                    if DamageUtils.is_player_unit(attacker) or was_pushed then
                        -- Hide the indicator
                        table.insert(saved_attackers, { index_with_offset, attacker})
                        damage_info[index_with_offset] = nil  -- Setting attacker to nil will hide the indicator
                        recent_damage_amount = damage_amount
                        recent_health = health_extension:current_health()
                        if attacker == player_unit then
                            damage_is_from_self = true
                        else
                            damage_is_from_self = false
                        end
                    end
                end
                    
            end
        end
    end

    func(self, dt)

    -- Restore saved attackers in case they are used elsewhere
    if #saved_attackers > 0 then
        for i = 1, #saved_attackers do
            damage_info[saved_attackers[i][1]] = saved_attackers[i][2]
        end
    end

end)

mod:hook(UnitFramesHandler, "update", function(func, self, ...)
    -- Catch FF and prepare to show alternate indicator

    local peer_id = self.peer_id
    local my_player = self.player_manager:player_from_peer_id(peer_id)
    local player_unit = my_player.player_unit
    
    if player_unit then
        -- Check recent damages for FF.
        local health_extension = ScriptUnit.extension(player_unit, "health_system")
        local damage_info, array_length = health_extension:recent_damages()
        
        if 0 < array_length then
            for i = 1, array_length/DamageDataIndex.STRIDE, 1 do
                local index = (i - 1) * DamageDataIndex.STRIDE
                local attacker = damage_info[index + DamageDataIndex.ATTACKER]
                local damage_type = damage_info[index + DamageDataIndex.DAMAGE_TYPE]

                -- If this damage is FF, find the HUD area of the attacking player and tell it to
                -- display the FF indicator.
                if DamageUtils.is_player_unit(attacker) then
                    if not ignored_damage_types[damage_type] then
                        for _, unit_frame in ipairs(self._unit_frames) do
                            local team_member = unit_frame.player_data.player
                            if team_member and team_member.player_unit == attacker and damage_info[DamageDataIndex.DAMAGE_AMOUNT] > 0 then
                                unit_frame.data._hudmod_ff_state = state.STARTING
                            end
                        end
                    end
                end
            end
        end
    end
    
    return func(self, ...)
end)

mod:hook(UnitFrameUI, "draw", function(func, self, dt)
    -- Show alternate FF indicator (red box around player portrait)

    local data = self.data
    
    if self._is_visible then
        local ui_renderer = self.ui_renderer
        local input_service = self.input_manager:get_service("ingame_menu")
        
        UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, input_service, dt, nil, self.render_settings)
        
        if data._hudmod_ff_state ~= nil then
            local widget = self._hudmod_ff_widget
            if refresh_widget or (not widget) then
                -- This is the first FF from this player, create the indicator widget for his HUD area.
                refresh_widget = false
                local rect = UIWidgets.create_simple_rect("pivot", Colors.get_table("firebrick"))
                local ui_depth = mod:get("position")
                if damage_is_from_self then
                    rect.style.rect.size = {640, 160}
                    rect.style.rect.offset = {-320, -45, ui_depth}
                else
                    rect.style.rect.size = {160, 222}
                    rect.style.rect.offset = {-80, -139, ui_depth}
                end
                widget = UIWidget.init(rect)
                self._hudmod_ff_widget = widget

                -- Assign these now to avoid getting them for every FF instance
                opacity_mult = mod:get("opacity_multiplier")
                duration_mult = mod:get("duration_multiplier")
                if ui_depth < 0 then
                    max_opacity = 255
                    min_opacity = 120 * opacity_mult
                else
                    max_opacity = 180 -- needs to be slightly transparent if it's going to be above anything
                    min_opacity = 90 * opacity_mult
                end
            end
 
            if data._hudmod_ff_state == state.STARTING then
                -- New damage, restart the animation.
                local importance_mult = mod.map_range(recent_health, 70,10, 1,3)  -- More opaque if you're on lower health
                animation_duration = (math.sqrt(recent_damage_amount*importance_mult/3)) * duration_mult
                opacity = mod.map_range(recent_damage_amount * opacity_mult * importance_mult, 0.25,8, min_opacity,max_opacity)
                UIWidget.animate(widget, UIAnimation.init(UIAnimation.function_by_time, widget.style.rect.color, 1, opacity, 0, animation_duration, math.easeInCubic))
                data._hudmod_ff_state = state.ONGOING
            end
 
            if UIWidget.has_animation(widget) then
                UIRenderer.draw_widget(ui_renderer, widget)
                self._dirty = true
            else
                -- Animation is finished, reset the FF state.
                data._hudmod_ff_state = nil
            end
        end
        
        UIRenderer.end_pass(ui_renderer)
    end
 
    return func(self, dt)
end)

mod:hook(PlayerUnitHealthExtension, "add_damage", function (func, self, attacker_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source_name, hit_ragdoll_actor, damaging_unit, hit_react_type, is_critical_strike, added_dot)

    mod:pcall(function()
        if DamageUtils.is_player_unit(attacker_unit) then
            if damage_type ~= "temporary_health_degen" then
                cur_time = os.time() -- Current time in seconds
                if ignore_this_ff[cur_time] ~= nil then
                    ignore_this_ff[cur_time] = ignore_this_ff[cur_time] + damage_amount
                else
                    ignore_this_ff[cur_time] = damage_amount
                end
                mod.debug_print("Total: "..tostring(ignore_this_ff[cur_time]).." This: "..tostring(damage_amount))
            end
        end
    end)

    return func(self, attacker_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source_name, hit_ragdoll_actor, damaging_unit, hit_react_type, is_critical_strike, added_dot)
end)

mod:hook(WwiseWorld, "trigger_event", function(func, ...)
    local arg = {...}
    if string.match(arg[2], "friendly_fire") then
        local cur_time = os.time()
        damage_threshold = 3.5 -- TODO make dynamic
        if ignore_this_ff[cur_time] ~= nil then
            if ignore_this_ff[cur_time] <= damage_threshold then
                mod.debug_print("Blocked FF dialog")
                ignore_this_ff[cur_time] = nil
                return -1, -1
            end
        end
    end
    return func(...)
end)


--[[
    Callback
--]]

mod.on_setting_changed = function(is_first_call)
    refresh_widget = true
end
