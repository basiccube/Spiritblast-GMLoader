#macro SB_UTILS_DLL "SpiritblastUtils.dll"

// Colors were originally macros but that won't work outside of this file
global.conhost_colors = {
	black : 0,
	blue : 1,
	green : 2,
	aqua : 3,
	red : 4,
	purple : 5,
	yellow : 6,
	white : 7,
	gray : 8,
	ltblue : 9,
	ltgreen : 10,
	ltaqua : 11,
	ltred : 12,
	ltpurple : 13,
	ltyellow : 14,
	brwhite : 15
}

global.sb_conhost_initialized = false

function conhost_func_init()
{
    if !file_exists(SB_UTILS_DLL)
        exit;

    global.conhost_init = external_define(SB_UTILS_DLL, "conhost_init", dll_cdecl, ty_real, 0) // conhost_init()
    global.conhost_free = external_define(SB_UTILS_DLL, "conhost_free", dll_cdecl, ty_real, 0) // conhost_free()
    global.conhost_is_allocated = external_define(SB_UTILS_DLL, "conhost_is_allocated", dll_cdecl, ty_real, 0) // conhost_is_allocated()
    global.conhost_write = external_define(SB_UTILS_DLL, "conhost_write", dll_cdecl, ty_real, 1, ty_string) // conhost_write(writeOutput)
    global.conhost_set_color = external_define(SB_UTILS_DLL, "conhost_set_color", dll_cdecl, ty_real, 2, ty_real, ty_real) // conhost_set_color(textColor, bgColor)
    global.conhost_title = external_define(SB_UTILS_DLL, "conhost_title", dll_cdecl, ty_real, 1, ty_string) // conhost_title(newTitle)

    global.sb_conhost_initialized = true
}

function conhost_init()
{
    if !global.sb_conhost_initialized
        exit;

    return external_call(global.conhost_init);
}

function conhost_free()
{
    if !global.sb_conhost_initialized
        exit;

    return external_call(global.conhost_free);
}

function conhost_is_allocated()
{
    if !global.sb_conhost_initialized
        exit;

    return external_call(global.conhost_is_allocated);
}

function conhost_write(writeOutput)
{
    if !global.sb_conhost_initialized
        exit;

    return external_call(global.conhost_write, writeOutput);
}

function conhost_set_color(textColor, bgColor)
{
    if !global.sb_conhost_initialized
        exit;

    return external_call(global.conhost_set_color, textColor, bgColor);
}

function conhost_title(newTitle)
{
    if !global.sb_conhost_initialized
        exit;

    return external_call(global.conhost_title, newTitle);
}