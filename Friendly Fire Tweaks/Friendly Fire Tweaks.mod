return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Friendly Fire Tweaks must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Friendly Fire Tweaks", {
			mod_script       = "scripts/mods/Friendly Fire Tweaks/Friendly Fire Tweaks",
			mod_data         = "scripts/mods/Friendly Fire Tweaks/Friendly Fire Tweaks_data",
			mod_localization = "scripts/mods/Friendly Fire Tweaks/Friendly Fire Tweaks_localization"
		})
	end,
	packages = {
		"resource_packages/Friendly Fire Tweaks/Friendly Fire Tweaks"
	}
}
