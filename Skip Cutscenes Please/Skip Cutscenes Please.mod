return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Skip Cutscenes Please must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Skip Cutscenes Please", {
			mod_script       = "scripts/mods/Skip Cutscenes Please/Skip Cutscenes Please",
			mod_data         = "scripts/mods/Skip Cutscenes Please/Skip Cutscenes Please_data",
			mod_localization = "scripts/mods/Skip Cutscenes Please/Skip Cutscenes Please_localization"
		})
	end,
	packages = {
		"resource_packages/Skip Cutscenes Please/Skip Cutscenes Please"
	}
}
