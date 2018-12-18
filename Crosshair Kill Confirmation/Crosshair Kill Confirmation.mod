return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Crosshair Kill Confirmation must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Crosshair Kill Confirmation", {
			mod_script       = "scripts/mods/Crosshair Kill Confirmation/Crosshair Kill Confirmation",
			mod_data         = "scripts/mods/Crosshair Kill Confirmation/Crosshair Kill Confirmation_data",
			mod_localization = "scripts/mods/Crosshair Kill Confirmation/Crosshair Kill Confirmation_localization"
		})
	end,
	packages = {
		"resource_packages/Crosshair Kill Confirmation/Crosshair Kill Confirmation"
	}
}
