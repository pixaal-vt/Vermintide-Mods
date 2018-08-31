return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Countries in Lobby Browser must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Countries in Lobby Browser", {
			mod_script       = "scripts/mods/Countries in Lobby Browser/Countries in Lobby Browser",
			mod_data         = "scripts/mods/Countries in Lobby Browser/Countries in Lobby Browser_data",
			mod_localization = "scripts/mods/Countries in Lobby Browser/Countries in Lobby Browser_localization"
		})
	end,
	packages = {
		"resource_packages/Countries in Lobby Browser/Countries in Lobby Browser"
	}
}
