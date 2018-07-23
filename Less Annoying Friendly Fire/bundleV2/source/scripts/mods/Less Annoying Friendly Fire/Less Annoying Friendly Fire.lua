local mod = get_mod("Less Annoying Friendly Fire")

--[[
    Hooks
--]]

mod:hook("PlayerUnitHealthExtension.add_damage", function (func, self, attacker_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source_name, hit_ragdoll_actor, damaging_unit, hit_react_type, is_critical_strike, added_dot)
    if DamageUtils.is_player_unit(attacker_unit) then
        if (mod:get("mode") == 3 and damage_amount < mod:get("threshold")) or mod:get("mode") == 2 then
            -- mod:echo("dmg " .. damage_type .." " .. tostring(damage_amount))  -- debug
            damage_type = "knockdown_bleed"  -- this damage type doesn't show the direction indicator
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