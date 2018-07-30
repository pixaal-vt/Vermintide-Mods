return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Stop Pushing Me must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Stop Pushing Me", {
			mod_script       = "scripts/mods/Stop Pushing Me/Stop Pushing Me",
			mod_data         = "scripts/mods/Stop Pushing Me/Stop Pushing Me_data",
			mod_localization = "scripts/mods/Stop Pushing Me/Stop Pushing Me_localization"
		})
	end,
	packages = {
		"resource_packages/Stop Pushing Me/Stop Pushing Me"
	}
}
