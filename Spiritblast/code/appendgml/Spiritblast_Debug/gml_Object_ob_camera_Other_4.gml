if (room == rm_splashScreen)
{
    if global.sb_settings.debug.skipSplash
    {
        print("Skip splash screens")
        room_goto(rm_logoDrop)
    }
}

sb_debug_collision_init()