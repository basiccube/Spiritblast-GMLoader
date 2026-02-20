conhost_func_init()

// Set up builtin function map
global.sb_builtinFunctions = ds_map_create()
for (var i = 0; i < 100000; i++)
{
	var funcname = script_get_name(i)
	if (funcname == "<unknown>")
		break;

	ds_map_set(global.sb_builtinFunctions, funcname, i)
}

// Load settings
sb_load_settings()

// Delete log if it exists
if file_exists(working_directory + "spiritblast.log")
	file_delete(working_directory + "spiritblast.log")

// Initialize console window if enabled
if global.sb_settings.debug.debugOutput
{
	conhost_init()
	conhost_title("ANTONBLAST (Console)")
}

// Print version info
print("Spiritblast")
print("Version " + sb_get_version())
print("=======================================")
print("")