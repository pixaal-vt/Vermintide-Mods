local mod = get_mod("Skip Cutscenes Please")

-- Everything here is optional. You can remove unused parts.
return {
	name = "Skip Cutscenes Please",
	description = mod:localize("mod_description"),
	is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "debug",
                type = "checkbox",
                default_value = false,
            }
        }
    }
}