local mod = get_mod("Stop Pushing Me")

--[[
	Hooks
--]]

mod:hook("PlayerUnitHealthExtension.add_damage", function (func, self, attacker_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source_name, hit_ragdoll_actor, damaging_unit, hit_react_type, is_critical_strike, added_dot)
    local local_player = Managers.player:local_player()
    if self.unit == local_player.player_unit then  -- Only catch pushes on self
        if DamageUtils.is_enemy(attacker_unit) then
            if damage_amount == 0 then  -- Pushes are always 0 damage
                damage_type = "knockdown_bleed"  -- This damage type doesn't show the direction indicator
            end
        end
    end

    -- Original function
    local result = func(self, attacker_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source_name, hit_ragdoll_actor, damaging_unit, hit_react_type, is_critical_strike, added_dot)
    return result
end)


--[[
    Callback
--]]

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(is_first_call)
    mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(is_first_call)
    mod:enable_all_hooks()
end
