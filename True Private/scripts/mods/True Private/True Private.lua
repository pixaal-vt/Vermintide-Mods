local mod = get_mod("True Private")

-- Based on IamLupo's mod for VT1

mod.is_priv = false  -- Main variable to track whether True Private is on or off.

-- For some reason table.pack is not always available, need to make our own
if not table.pack then
    function table.pack (...)
        return {n=select('#',...); ...}
    end
end

mod.players = function(self)
    -- Return table of players with id as key and name as value
    local player_manager = Managers.player
    local players = player_manager:human_players()
    local player_arr = {}
    for _, player in pairs(players) do
        player_arr[player.peer_id] = player._cached_name
    end
    return player_arr
end

mod.set_priv = function(self, priv)
    if Managers.player.is_server then
        mod.is_priv = priv
        if mod.is_priv and Managers.state.game_mode._game_mode_key == "adventure" then
            -- If currently in a mission, set it to Private to hide it in the lobby browser.
            local matchmaking_manager = Managers.matchmaking
            matchmaking_manager:set_in_progress_game_privacy(true)
        end
        mod:chat_broadcast(mod.is_priv and "True Private is now ON" or "True Private is now OFF")
    else
        mod:echo("Only the host can enable True Private.")
    end
end

local cmd_enable_description = [[
Toggle True Private mode and prevent anyone from joining you, even steam friends.
]]
mod:command("trueprivate", cmd_enable_description, function(...)
    mod:set_priv(not mod.is_priv)
end)


--[[
    Hooks
--]]
mod:hook(NetworkTransmit, "send_rpc", function(func, self, rpc_name, peer_id, ...)
    if mod.is_priv and rpc_name == "rpc_matchmaking_request_join_lobby_reply" and Managers.player.is_server then
        mod:chat_whisper(peer_id, "The lobby you are trying to join is using the True Private mod to prevent anyone (even steam friends) from joining.")
        local players = mod:players()
        local msg = "True Private is enabled, preventing player from joining."
        for id, name in pairs(players) do  -- Whisper to everyone except the person trying to join
            if id ~= peer_id then
                mod:chat_whisper(id, msg)
            end
        end
        mod:echo(msg)  -- Whisper doesn't work to self (?!), have to echo instead.

        local args = table.pack(...)
        local reply = "not_searching_for_players"  -- Will prevent them joining and show "Lobby is private" error.
        local reply_id = NetworkLookup.game_ping_reply[reply]
        
        return func(self, rpc_name, peer_id, args[1], args[2], reply_id)
    else
        return func(self, rpc_name, peer_id, ...)
    end
end)

mod:hook(MatchmakingManager, "set_in_progress_game_privacy", function (func, self, is_private)
    if mod.is_priv and (not is_private) then
        mod:set_priv(is_private)
    end
    func(self, is_private)
end)

mod:hook(MatchmakingStateHostGame, "_start_hosting_game", function (func, self)
    if mod.is_priv and self.search_config.quick_game and Managers.player.is_server then
        -- Don't allow private quickplays
        mod:echo("True Private is disabled in Quickplay")
        mod.is_priv = false
    end
    if mod.is_priv and Managers.player.is_server then
        self.search_config.private_game = true  -- Prevent public matchmaking.
    end
    func(self)
end)


--[[
    Callbacks
--]]
mod.on_game_state_changed = function(status, state)
    -- Reminder after loading screens if True Private is enabled.
    if mod.is_priv and Managers.player.is_server and status == "enter" and state == "StateIngame" then
        mod:echo("Reminder: True Private is ON.")
    end
    return
end

mod.on_enabled = function(first_call)
    if not first_call then
        -- Some people may think just turning the mod on will enable True Private
        mod:echo("True Private is disabled by default - you need to type \"/trueprivate\" to enable/disable it.")
    end
end

mod.on_disabled = function(first_call)
    if not first_call and Managers.player.is_server then
        mod:chat_broadcast("True Private is now OFF")
    end
end
