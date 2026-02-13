if (room == rm_template_room)
    RoomLoader.InitializeRoom()
else if (room == rm_mainMenu)
    RoomLoader.ClearInstanceMap()
else if (room == rm_splashScreen)
{
    RoomLoader.ClearInstanceMap()
    if global.sb_settings.debug.skipSplash
    {
        print("Skip splash screens")
        room_goto(rm_logoDrop)
    }
}

sb_debug_collision_init()