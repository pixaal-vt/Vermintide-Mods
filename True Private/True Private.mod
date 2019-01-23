return {
	run = function()
		fassert(rawget(_G, "new_mod"), "True Private must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("True Private", {
			mod_script       = "scripts/mods/True Private/True Private",
			mod_data         = "scripts/mods/True Private/True Private_data",
			mod_localization = "scripts/mods/True Private/True Private_localization"
		})
	end,
	packages = {
		"resource_packages/True Private/True Private"
	}
}
