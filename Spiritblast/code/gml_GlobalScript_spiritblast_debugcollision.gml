// The game already has the functionality for drawing the collision,
// but I'm doing it my way anyway

global.sb_debugCollisionData = []
global.sb_debugCollisionDataBG = []
global.sb_showDebugCollisions = false

global.sb_debugCollisionObjects = [ob_block, ob_passthrough, ob_passthroughSlope14,
									ob_passthroughSlope22, ob_passthroughSlope45,
									ob_slope14, ob_slope22, ob_slope45, ob_ladder]
									
global.sb_debugCollisionObjectsBG = [ob_block_BG, ob_passthrough_BG, ob_ladder_BG,
									ob_passthroughSlope22_BG, ob_passthroughSlope45_BG,
									ob_slope12_BG, ob_slope22_BG, ob_slope45_BG]

function sb_debug_collision_init()
{
	var get_data_func = function(obj, lay = 0)
	{
		with (obj)
		{
			if (object_index != obj)
				continue;
			if (gameplayLayer != lay)
				continue;
			
			var data = {
				sprite : sprite_index,
				x : x,
				y : y,
				xscale : image_xscale,
				yscale : image_yscale,
				angle : image_angle
			}
			
			if !sprite_exists(sprite_index)
			{
				print(sprite_index, "- not a valid sprite, ignoring...")
				continue;
			}
			
			if (gameplayLayer > 0)
				array_push(global.sb_debugCollisionDataBG, data)
			else
				array_push(global.sb_debugCollisionData, data)
		}
	}
	
	print("Getting debug collision sprite data")
	
	for (var i = 0, n = array_length(global.sb_debugCollisionObjects); i < n; i++)
		get_data_func(global.sb_debugCollisionObjects[i])
	
	for (var i = 0, n = array_length(global.sb_debugCollisionObjectsBG); i < n; i++)
		get_data_func(global.sb_debugCollisionObjectsBG[i], 1)
}

function sb_debug_collision_clear()
{
	print("Clearing debug collision sprite data")
	global.sb_debugCollisionData = []
	global.sb_debugCollisionDataBG = []
	gc_collect()
}

function sb_debug_collision_draw()
{
	if !global.sb_showDebugCollisions
		exit;
	
	for (var i = 0, n = array_length(global.sb_debugCollisionData); i < n; i++)
	{
		var data = global.sb_debugCollisionData[i]
		draw_sprite_ext(data.sprite, 0, data.x, data.y, data.xscale, data.yscale, data.angle, c_white, 1)
	}
}

function sb_debug_collision_drawBG()
{
	if !global.sb_showDebugCollisions
		exit;
	
	var camX = camera_get_view_x(view_camera[0])
	for (var i = 0, n = array_length(global.sb_debugCollisionDataBG); i < n; i++)
	{
		var data = global.sb_debugCollisionDataBG[i]
		draw_sprite_ext(data.sprite, 0, data.x + 25 + (camX * 0.5), data.y, data.xscale, data.yscale, data.angle, c_white, 1)
	}
}