local mod = get_mod("Less Annoying Friendly Fire")

-- Everything here is optional. You can remove unused parts.
return {
	name = "Less Annoying Friendly Fire",           -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	is_mutator = false,                             -- If the mod is mutator
	mutator_settings = {},                          -- Extra settings, if it's mutator
	options_widgets = {                             -- Widget settings for the mod options menu
		{
			["setting_name"] = "mode",
			["widget_type"] = "dropdown",
			["text"] = "Indicator",
			["tooltip"] = "",
			["options"] = {
				{ text = "Always Enabled", value = 1 }, --1
				{ text = "Always Disabled", value = 2 }, --2
				{ text = "Only Above Threshold", value = 3 }, --3
			},
			["default_value"] = 3,
			["sub_widgets"] = {
				{
					["show_widget_condition"] = {3},
					["setting_name"] = "threshold",
					["widget_type"] = "numeric",
					["text"] = "Damage Threshold",
					["tooltip"] = "Damage lower than this will not show the red arrow indicator",
					["range"] = {0, 30},
					["default_value"] = 3,
				},
			},
		},
		{
			["setting_name"] = "debug",
			["widget_type"] = "checkbox",
			["text"] = "Debug Mode",
			["tooltip"] = "Show FF damage numbers in chat.",
			["default_value"] = true,
		},
	}
}