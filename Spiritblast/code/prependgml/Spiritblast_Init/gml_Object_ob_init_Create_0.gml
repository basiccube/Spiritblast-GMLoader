#macro SB_UTILS_DLL "SpiritblastUtils.dll"

global.conhost_init = external_define(SB_UTILS_DLL, "conhost_init", dll_cdecl, ty_real, 0)
global.conhost_free = external_define(SB_UTILS_DLL, "conhost_free", dll_cdecl, ty_real, 0)
global.conhost_is_allocated = external_define(SB_UTILS_DLL, "conhost_is_allocated", dll_cdecl, ty_real, 0)
global.conhost_write = external_define(SB_UTILS_DLL, "conhost_write", dll_cdecl, ty_real, 1, ty_string)
global.conhost_set_color = external_define(SB_UTILS_DLL, "conhost_set_color", dll_cdecl, ty_real, 2, ty_real, ty_real)
global.conhost_title = external_define(SB_UTILS_DLL, "conhost_title", dll_cdecl, ty_real, 1, ty_string)

#macro CONHOST_BLACK 0
#macro CONHOST_BLUE 1
#macro CONHOST_GREEN 2
#macro CONHOST_AQUA 3
#macro CONHOST_RED 4
#macro CONHOST_PURPLE 5
#macro CONHOST_YELLOW 6
#macro CONHOST_WHITE 7
#macro CONHOST_GRAY 8
#macro CONHOST_LTBLUE 9
#macro CONHOST_LTGREEN 10
#macro CONHOST_LTAQUA 11
#macro CONHOST_LTRED 12
#macro CONHOST_LTPURPLE 13
#macro CONHOST_LTYELLOW 14
#macro CONHOST_BRWHITE 15

// Initialize console window
external_call(global.conhost_init)
external_call(global.conhost_title, "ANTONBLAST (Console)")

// Delete log if it exists
if file_exists(working_directory + "spiritblast.log")
	file_delete(working_directory + "spiritblast.log")

// Print version info
print("Spiritblast")
print("Version " + sb_get_version())
print("=======================================")
print("")

// Load settings
sb_load_settings()