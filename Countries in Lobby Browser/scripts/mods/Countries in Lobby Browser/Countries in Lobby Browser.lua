local mod = get_mod("Countries in Lobby Browser")

--[[
    Functions
--]]

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

--[[
    Hooks
--]]

mod:hook(LobbyItemsList, "populate_lobby_list", function(func, self, lobbies, ...)

    local sort_func = self.sort_lobbies_function
    local valid_lobbies = self:remove_invalid_lobbies(lobbies)

    if sort_func then
        self:sort_lobbies(valid_lobbies, sort_func)
    end

    local my_peer_id = Network:peer_id()
    for lobby_id, lobby_data in pairs(valid_lobbies) do

        ---- Semi-copy pasta from lobby_item_list.lua / create_lobby_list_entry_content to get only valid lobbies ----
        local host = lobby_data.host
        local title_text = lobby_data.server_name or lobby_data.unique_server_name or lobby_data.name or lobby_data.host

        local continue = true
        if host == my_peer_id or not title_text then
            continue = false
        end
        ---- End copy pasta ----

        if continue then
            country_code_text = '['..lobby_data.country_code..'] '
            if not starts_with(title_text, country_code_text) then
                modded_title = country_code_text .. title_text
                lobby_data.server_name = modded_title  -- 'server_name' is the first name that create_lobby_list_entry_content will use out of 'server_name', 'unique_server_name', 'name' and 'host'
                -- It's safe to modify lobby_data.server_name as it is only used for display in the lobby browser
            end
        end
    end

    func(self, lobbies, ...)
end)


--[[
    Callbacks
--]]

-- All callbacks are called even when the mod is disabled

-- Called when the checkbox for this mod is unchecked
mod.on_disabled = function(is_first_call)
    mod:disable_all_hooks()
end

-- Called when the checkbox for this is checked
mod.on_enabled = function(is_first_call)
    mod:enable_all_hooks()
end
