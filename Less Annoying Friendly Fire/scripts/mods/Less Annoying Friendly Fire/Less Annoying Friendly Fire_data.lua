local mod = get_mod("Less Annoying Friendly Fire")

-- Everything here is optional. You can remove unused parts.
return {
	name = "Less Annoying Friendly Fire",           -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	options_widgets = {                             -- Widget settings for the mod options menu
		{
			["setting_name"] = "hide_pushes",
			["widget_type"] = "checkbox",
			["text"] = "Hide Pushes",
			["tooltip"] = "Hide the indicator when enemies push you (which deals 0 damage, but still shows the indicator). Affects, stormvermin, maulers, chaos warriors, dodged packmasters, etc.",
			["default_value"] = true,
		},
		{
			["setting_name"] = "opacity_multiplier",
			["widget_type"] = "numeric",
			["text"] = "Opacity multiplier",
			["tooltip"] = "The opacity/transparency of the red friendly fire box is determined by how much damage you take. If you're having trouble noticing the red box, increase this multiplier.",
			["default_value"] = 1,
			["range"] = {0, 2},
			["decimals_number"] = 2,
		},
		{
			["setting_name"] = "duration_multiplier",
			["widget_type"] = "numeric",
			["text"] = "Duration multiplier",
			["tooltip"] = "The duration that the red friendly fire box is shown is determined by how much damage you take. If you're having trouble noticing the red box, increase this multiplier.",
			["default_value"] = 1,
			["range"] = {0, 4},
			["decimals_number"] = 2,
		},
		{
			["setting_name"] = "position",
			["widget_type"] = "dropdown",
			["text"] = "Position",
			["tooltip"] = "Whether the red friendly fire box is shown above or below player portraits.",
			["default_value"] = -100,
			options = {
				{text="Below", value=-100},
				{text="Above", value=100},
			},
		},
		{
			["setting_name"] = "debug",
			["widget_type"] = "checkbox",
			["text"] = "Debug Mode",
			["tooltip"] = "Show damage dealt to you in chat (visible only to you).",
			["default_value"] = false,
		},
	}
}