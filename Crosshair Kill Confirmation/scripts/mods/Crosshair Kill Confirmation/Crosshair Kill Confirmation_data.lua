local mod = get_mod("Crosshair Kill Confirmation")

return {
	name = "Crosshair Kill Confirmation",           -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	options = {                                     -- Widget settings for the mod options menu
		widgets = {
			{
				setting_id = "duration",
				type = "numeric",
				default_value = 1,
				range = {0, 4},
				decimals_number = 2,
			},
			{
				setting_id = "size",
				type = "numeric",
				default_value = 52,
				range = {0, 128},
				decimals_number = 0,
			},
			{
				setting_id = "pop",
				type = "numeric",
				default_value = 2.2,
				range = {1, 10},
				decimals_number = 1,
			},
			{
				setting_id = "crosshair_normal",
				type = "dropdown",
				default_value = "ex",
				options = {
					{text="option_circle", value="circle"},
					{text="option_dot", value="dot"},
					{text="option_ex", value="ex"},
					{text="option_plus", value="plus"},
					{text="option_square", value="square"},
					{text="option_triangle", value="triangle"},
					{text="option_heart", value="heart"},
					{text="option_none", value="none"},
				},
			},
			{
				setting_id = "crosshair_special",
				type = "dropdown",
				default_value = "circle",
				options = {
					{text="option_circle", value="circle"},
					{text="option_dot", value="dot"},
					{text="option_ex", value="ex"},
					{text="option_plus", value="plus"},
					{text="option_square", value="square"},
					{text="option_triangle", value="triangle"},
					{text="option_heart", value="heart"},
					{text="option_none", value="none"},
				},
			},
			{
				setting_id = "crosshair_elite",
				type = "dropdown",
				default_value = "triangle",
				options = {
					{text="option_circle", value="circle"},
					{text="option_dot", value="dot"},
					{text="option_ex", value="ex"},
					{text="option_plus", value="plus"},
					{text="option_square", value="square"},
					{text="option_triangle", value="triangle"},
					{text="option_heart", value="heart"},
					{text="option_none", value="none"},
				},
			},
			{
				setting_id = "crosshair_boss",
				type = "dropdown",
				default_value = "square",
				options = {
					{text="option_circle", value="circle"},
					{text="option_dot", value="dot"},
					{text="option_ex", value="ex"},
					{text="option_plus", value="plus"},
					{text="option_square", value="square"},
					{text="option_triangle", value="triangle"},
					{text="option_heart", value="heart"},
					{text="option_none", value="none"},
				},
			},
		}
	}
}