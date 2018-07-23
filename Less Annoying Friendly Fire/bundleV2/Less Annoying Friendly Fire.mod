return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Less Annoying Friendly Fire must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Less Annoying Friendly Fire", {
			mod_script       = "scripts/mods/Less Annoying Friendly Fire/Less Annoying Friendly Fire",
			mod_data         = "scripts/mods/Less Annoying Friendly Fire/Less Annoying Friendly Fire_data",
			mod_localization = "scripts/mods/Less Annoying Friendly Fire/Less Annoying Friendly Fire_localization"
		})
	end,
	packages = {
		"resource_packages/Less Annoying Friendly Fire/Less Annoying Friendly Fire"
	}
}
