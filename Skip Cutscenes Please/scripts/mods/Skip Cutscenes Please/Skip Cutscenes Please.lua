--[[
Based heavily on Aussiemon's skip cutscenes mod, with modifications to make it sanctionable.

Original license:
    Copyright 2018 Aussiemon

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--


local mod = get_mod("Skip Cutscenes Please")

--[[ TODO
    Automatically skip every cutscene after you've seen it once before.
]]--

mod.skip_next_fade = false -- Track the need to skip the fade effect
mod.players_with_mod = {} -- Track which players use this mod 

local ShowCursorStack = ShowCursorStack

mod.debug_print = function(self, text)
    if mod:get("debug") == true then
        mod:echo(text)
    end
end

-- mod:command("skip", "Skip", function(...)
--     mod:debug_print("hello!")
-- end)


-- Skip fade when applicable
mod:hook(CutsceneSystem, "flow_cb_cutscene_effect", function (func, self, name, ...)
    if name == "fx_fade" and (mod.skip_next_fade) then
        mod.skip_next_fade = false
        return
    end
    
    return func(self, name, ...)
end)

-- Don't restore player input if player already has active input
mod:hook(CutsceneSystem, "flow_cb_deactivate_cutscene_logic", function (func, self, event_on_deactivate, ...)
    -- If a popup is open or cursor present, skip the input restore
    if ShowCursorStack.stack_depth > 0 or Managers.popup:has_popup() then
        if event_on_deactivate then
            local level = LevelHelper:current_level(self.world)
            Level.trigger_event(level, event_on_deactivate)
        end

        self.event_on_skip = nil
        return
    end

    return func(self, event_on_deactivate, ...)
end)

-- Prevent invalid cursor pop crash if another mod interferes
mod:hook(ShowCursorStack, "pop", function (func, ...)
    -- Catch a starting depth of 0 or negative cursors before pop
    if ShowCursorStack.stack_depth <= 0 then
        mod:echo("[Warning]: Attempt to remove non-existent cursor.")
        return
    end
    
    return func(...)
end)

mod:hook(CutsceneSystem, "skip_pressed", function (func, ...)
    local local_player = Managers.player:local_player()
    local players = Managers.player:human_players()
    local allow_skip = true
    for _, player in pairs(players) do
        mod:debug_print(tostring(player.peer_id).." "..tostring(mod.players_with_mod[player.peer_id]))
        if mod.players_with_mod[player.peer_id] == nil and player.peer_id ~= local_player.peer_id then
            allow_skip = false
            mod:echo("Can't skip cutscene because "..(player._cached_name or "someone").." doesn't have this mod.")
        end
    end

    if allow_skip == true then
        script_data.skippable_cutscenes = true
        mod.skip_next_fade = true
        mod:debug_print("allowing skip")
    else
        script_data.skippable_cutscenes = false
        mod.skip_next_fade = false
        mod:debug_print("nope")
    end
    
    -- Original function
    return func(...)
end)

mod:network_register("rpc_pls_skip_cutscene", function(sender_peer_id)
    mod:debug_print("Roger "..tostring(sender_peer_id))
    mod.players_with_mod[sender_peer_id] = true
end)


-- ##########################################################
-- ################### Callback #############################

mod.on_disabled = function(initial_call)
    script_data.skippable_cutscenes = false
end

mod.on_user_joined = function(player)
    mod:debug_print((player._cached_name or tostring(player.peer_id)).." joined")
    mod:network_send("rpc_pls_skip_cutscene", "all")
end
