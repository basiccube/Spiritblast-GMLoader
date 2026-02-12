#macro SB_SETTINGS_FILE "spiritblast_settings.ini"

// Version number stuff
#macro SB_VERSION_MAJOR 0
#macro SB_VERSION_MINOR 4
#macro SB_VERSION_PATCH 0

function sb_get_version()
{
	return string(SB_VERSION_MAJOR) + "." + string(SB_VERSION_MINOR) + "." + string(SB_VERSION_PATCH);
}

// Mod settings
global.sb_settings = {
	borderlessFullscreen : false,
	debugOverlay : false,
	debugControls : false,
	skipSplash : false
}

// Real all custom settings from the settings INI.
function sb_load_settings()
{
	ini_open(SB_SETTINGS_FILE)
	
	global.sb_settings.borderlessFullscreen = ini_read_real("Video", "BorderlessFullscreen", false)
	global.sb_settings.debugOverlay = ini_read_real("Debug", "DebugOverlay", false)
	global.sb_settings.debugControls = ini_read_real("Debug", "DebugControls", false)
	global.sb_settings.skipSplash = ini_read_real("Debug", "SkipSplash", false)
	
	ini_close()
}