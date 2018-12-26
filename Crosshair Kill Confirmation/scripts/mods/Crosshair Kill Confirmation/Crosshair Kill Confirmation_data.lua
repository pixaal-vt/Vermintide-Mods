local mod = get_mod("Crosshair Kill Confirmation")

return {
	name = "Crosshair Kill Confirmation",           -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	options_widgets = {                             -- Widget settings for the mod options menu
		{
			["setting_name"] = "duration",
			["widget_type"] = "numeric",
			["text"] = "Duration",
			["tooltip"] = "How long the indicator is shown for when killing an enemy (in seconds).\nDefault: 1.2",
			["default_value"] = 1.2,
			["range"] = {0, 4},
			["decimals_number"] = 2,
		},
		{
			["setting_name"] = "size",
			["widget_type"] = "numeric",
			["text"] = "Size",
			["tooltip"] = "How big the kill indicator is.\nDefault: 60",
			["default_value"] = 60,
			["range"] = {0, 128},
			["decimals_number"] = 0,
		},
		{
			["setting_name"] = "pop",
			["widget_type"] = "numeric",
			["text"] = "Pop effect",
			["tooltip"] = "For elites, sepecials and monsters, the kill indicator grows a bit as it fades out, making a sort of \"pop\" effect. This controls how much it grows by.\nDefault: 2",
			["default_value"] = 2,
			["range"] = {1, 10},
			["decimals_number"] = 1,
		},
		{
			["setting_name"] = "crosshair_normal",
			["widget_type"] = "dropdown",
			["text"] = "Normal kills",
			["tooltip"] = "Choose the appearance of the kill indicator crosshair for regular enemies.\nDefault: Ex",
			["default_value"] = "ex",
			options = {
				{text="Circle", value="circle"},
				{text="Dot", value="dot"},
				{text="Ex", value="ex"},
				{text="Plus", value="plus"},
				{text="Square", value="square"},
				{text="Triangle", value="triangle"},
				{text="Heart", value="heart"},
			},
		},
		{
			["setting_name"] = "crosshair_special",
			["widget_type"] = "dropdown",
			["text"] = "Special kills",
			["tooltip"] = "Choose the appearance of the kill indicator crosshair for specials.\nDefault: Circle",
			["default_value"] = "circle",
			options = {
				{text="Circle", value="circle"},
				{text="Dot", value="dot"},
				{text="Ex", value="ex"},
				{text="Plus", value="plus"},
				{text="Square", value="square"},
				{text="Triangle", value="triangle"},
				{text="Heart", value="heart"},
			},
		},
		{
			["setting_name"] = "crosshair_elite",
			["widget_type"] = "dropdown",
			["text"] = "Elite kills",
			["tooltip"] = "Choose the appearance of the kill indicator crosshair for stronger/elite enemies.\nDefault: Triangle",
			["default_value"] = "triangle",
			options = {
				{text="Circle", value="circle"},
				{text="Dot", value="dot"},
				{text="Ex", value="ex"},
				{text="Plus", value="plus"},
				{text="Square", value="square"},
				{text="Triangle", value="triangle"},
				{text="Heart", value="heart"},
			},
		},
		{
			["setting_name"] = "crosshair_boss",
			["widget_type"] = "dropdown",
			["text"] = "Boss kills",
			["tooltip"] = "Choose the appearance of the kill indicator crosshair for monsters and lords.\nDefault: Square",
			["default_value"] = "square",
			options = {
				{text="Circle", value="circle"},
				{text="Dot", value="dot"},
				{text="Ex", value="ex"},
				{text="Plus", value="plus"},
				{text="Square", value="square"},
				{text="Triangle", value="triangle"},
				{text="Heart", value="heart"},
			},
		},
	}
}