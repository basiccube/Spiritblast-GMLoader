#macro SB_SETTINGS_FILE "spiritblast_settings.json"

// Version number stuff
#macro SB_VERSION_MAJOR 0
#macro SB_VERSION_MINOR 4
#macro SB_VERSION_PATCH 0

function sb_get_version()
{
	return string(SB_VERSION_MAJOR) + "." + string(SB_VERSION_MINOR) + "." + string(SB_VERSION_PATCH);
}

function sb_mod_settings() constructor
{
	video = {
		borderlessFullscreen : false
	}

	debug = {
		debugOverlay : false,
		debugControls : false,
		debugOutput : false,
		skipSplash : false
	}
}

// Mod settings
global.sb_settings = undefined

function sb_update_settings()
{
	// window_enable_borderless_fullscreen isn't recognized as a function in UTMT
	// so I have to do this shit instead
	ds_map_find_value(global.sb_builtinFunctions, "window_enable_borderless_fullscreen")(global.sb_settings.video.borderlessFullscreen)
	show_debug_overlay(global.sb_settings.debug.debugOverlay)
}

// Read all custom settings from the settings file.
function sb_load_settings()
{
	if !file_exists(SB_SETTINGS_FILE)
	{
		global.sb_settings = new sb_mod_settings()
		exit;
	}

	var jsonstr = file_text_read_all(SB_SETTINGS_FILE)
	global.sb_settings = json_parse(jsonstr)

	sb_update_settings()
}

// Saves all custom settings to the settings file.
function sb_save_settings()
{
	var jsonstr = json_stringify(global.sb_settings, true)

	var file = file_text_open_write(SB_SETTINGS_FILE)
	file_text_write_string(file, jsonstr)
	file_text_close(file)

	sb_update_settings()
}