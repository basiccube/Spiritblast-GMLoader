// Debug collision visibility
if keyboard_check_pressed(vk_f4)
	global.sb_showDebugCollisions = !global.sb_showDebugCollisions

// Go to specified menu
if keyboard_check_pressed(vk_f5)
{
	var inputString = get_string("Type the variable name of the page you want to go to:", "mainPage")
	if (inputString != "")
	{
		with (ob_listMenu)
		{
			var page = variable_instance_get(id, inputString)
			if !is_undefined(page)
				changePage(page)
		}
	}
}