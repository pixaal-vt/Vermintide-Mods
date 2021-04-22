local mod = get_mod("Countries in Lobby Browser")

local filter = ""

--[[
    Functions
--]]

local cmd_country_description = [[
Filter the lobby browser with hosts from this country.
Separate multiple countries with spaces.
Reset by running /country with no parameters.
]]

mod:command("country", cmd_country_description, function(...)
    filter = table.concat({...}, " ")
    if filter == "" then
        mod:echo("Lobby filter reset.")
    else
        mod:echo("Lobby filter changed, click \"Search\" to update the list. Reset the filter by running /country with no parameters.")
    end
end)

--[[
    Hooks
--]]

mod:hook(LobbyItemsList, "remove_invalid_lobbies", function(func, self, lobbies)
    local filtered_lobbies = {}
    local num_lobbies = #lobbies

    local i = 0
    for lobby_id, lobby_data in pairs(lobbies) do
        i = i + 1
        local title_text = lobby_data.server_name or lobby_data.unique_server_name or lobby_data.name or lobby_data.host

        if filter == "" or (lobby_data.country_code ~= nil and string.find(filter, lobby_data.country_code)) then
            filtered_lobbies[#filtered_lobbies + 1] = lobbies[i]
        end
    end

    return func(self, filtered_lobbies)
end)

mod:hook_safe(LobbyItemsList, "populate_lobby_list", function (self)
  for _, content in ipairs(self.item_list_widget.content.list_content) do
    if content.lobby_data then
        content.title_text = string.format("[%s] %s", content.lobby_data.country_code, content.title_text)
    end
  end
end)
