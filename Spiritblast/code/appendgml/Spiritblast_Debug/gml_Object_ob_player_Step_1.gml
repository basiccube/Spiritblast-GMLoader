// Check if the debug overlay is open and disable player input
if is_debug_overlay_open()
{
    var inputObject = ob_playerInputManager
	if ds_map_find_value(global.sb_builtinFunctions, "is_keyboard_used_debug_overlay")()
	{
		if instance_exists(inputObject)
			instance_deactivate_object(inputObject)
	}
	else
	{
		if !instance_exists(inputObject)
			instance_activate_object(inputObject)
	}
}