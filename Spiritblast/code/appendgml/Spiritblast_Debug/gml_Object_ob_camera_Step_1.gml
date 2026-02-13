if global.sb_settings.debug.debugControls
{
	// Debug collision visibility
	if keyboard_check_pressed(vk_f4)
		global.sb_showDebugCollisions = !global.sb_showDebugCollisions

	// Go to specified menu
	if keyboard_check_pressed(vk_f5)
	{
		var inputString = get_string("Type the variable name of the page you want to go to:", "mainPage")
		if (inputString != "")
		{
			if !instance_exists(ob_listMenu)
				print("There aren't any menus currently open!")
			
			with (ob_listMenu)
			{
				var page = variable_instance_get(id, inputString)
				if !is_undefined(page)
					changePage(page)
			}
		}
	}
}

// Check if the debug overlay is open and disable global input
if is_debug_overlay_open()
{
    var inputObject = ob_globalInput
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