local mod = get_mod("Friendly Fire Tweaks")

-- Everything here is optional. You can remove unused parts.
return {
	name = "Friendly Fire Tweaks",                  -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	is_mutator = false,                             -- If the mod is mutator
	mutator_settings = {},                          -- Extra settings, if it's mutator
	options_widgets = {                             -- Widget settings for the mod options menu
		{
			["setting_name"] = "mode",
			["widget_type"] = "dropdown",
			["text"] = "Friendly Fire Indicator",
			["tooltip"] = "",
			["options"] = {
				{ text = "Enabled", value = 1 }, --1
				{ text = "Disabled", value = 2 }, --2
				{ text = "Threshold", value = 3 }, --3
			},
			["default_value"] = 2,
			["sub_widgets"] = {
				{
					["show_widget_condition"] = {3},
					["setting_name"] = "threshold",
					["widget_type"] = "numeric",
					["text"] = "Damage Threshold",
					["tooltip"] = "Damage lower than this will not show the indicator",
					["range"] = {0, 30},
					["default_value"] = 3,
				},
			},
		},
	}
}