#macro ROOM_VERSION 1

function RoomLoader() constructor
{
    static currentRoom = "";
    static firstRoom = "";
    static levelName = "";

    static roomData = undefined;
    static instanceMap = ds_map_create()

    static GetInstanceIDString = function(objname, x, y)
    {
        var instString = objname + "_" + string(x) + "_" + string(y)
        return instString;
    }

    static ClearInstanceMap = function()
    {
        print("Clearing room loader instance map...")
        ds_map_clear(instanceMap)
    }

    static CheckInstancesInRoomList = function()
    {
        if !ds_map_exists(instanceMap, currentRoom)
            exit;

        var instances = ds_map_find_value(instanceMap, currentRoom)
        for (var i = 0, n = array_length(instances); i < n; i++)
        {
            var exists = false
            var instString = instances[i]

            // This is still not a good way to do it, and it's possibly worse now that it's in GML
            for (var j = 0; j < instance_count; j++)
            {
                var instID = instance_id_get(j)
                if !instance_exists(instID)
                    continue;

                var name = object_get_name(instID.object_index)

                var istr = GetInstanceIDString(name, instID.x, instID.y)
                if (istr == instString)
                {
                    exists = true
                    break;
                }
            }

            if !exists
            {
                array_delete(instances, i, 1)
                n--
                i--
            }
        }
    }

    static CreateStageData = function()
    {
        // Makes a copy of the data for Cinnamon Springs
		// that will be used as the base for the custom stage
        var baseStage = struct_get(ob_stageManager.stages, "cinnamonSprings")
        var newStage = variable_clone(baseStage)

        newStage.name = "customStage"
        newStage.initialMusic = mu_jamLayerA
        newStage.firstRoom = rm_template_room

        struct_set(ob_stageManager.stages, "customStage", newStage)
        return newStage;
    }

    static LoadRoomData = function(path)
    {
        if !file_exists(path)
        {
            print("Room file", path, "doesn't exist")
            return undefined;
        }

        var jsonstr = file_text_read_all(path)
        if (jsonstr == "")
        {
            print("Failed to read room file", path)
            return undefined;
        }

        var json = json_parse(jsonstr)
        return json;
    }

    static GoToRoom = function(level, name)
    {
        roomData = LoadRoomData("levels/" + level + "/" + name + ".rfrm")
        if is_undefined(roomData)
        {
            print("Cannot go to room", name)
            exit;
        }

        if (roomData.rf_roomversion != ROOM_VERSION)
        {
            print("Incorrect room version!")
            print("Expected", ROOM_VERSION, ", got", roomData.rf_roomversion)
            exit;
        }

        CheckInstancesInRoomList()
        currentRoom = name
        levelName = level

        print("Preparing room")
        room_set_width(rm_template_room, roomData.roomInfo.width)
        room_set_height(rm_template_room, roomData.roomInfo.height)

        print("Going to the template room now!")
        room_goto(rm_template_room)
    }

    static PlayCustomLevel = function(level)
    {
        print("Playing level", level)

        firstRoom = "room"
        ClearInstanceMap()
        GoToRoom(level, "room")
    }

    static InitializeRoom = function()
    {
        var firstTime = false
        if !ds_map_exists(instanceMap, currentRoom)
        {
            print("Setting up", currentRoom, "for the first time")
            ds_map_set(instanceMap, currentRoom, [])
            firstTime = true
        }

        var instanceList = ds_map_find_value(instanceMap, currentRoom)

        // Create all layers and objects for the room
        for (var i = 0, n = array_length(roomData.layers); i < n; i++)
        {
            var lay = roomData.layers[i]
            var layName = lay.name
            var layDepth = lay.depth

            if !layer_exists(layName)
                layer_create(layDepth, layName)

            var layID = layer_get_id(layName)
            for (var j = 0, m = array_length(lay.instances); j < m; j++)
            {
                var instdata = lay.instances[j]
                var instobj = asset_get_index(instdata.id)
                if (instobj == -1)
                    continue;

                var inst = instance_create_layer(instdata.x, instdata.y, layID, instobj)
                var instString = GetInstanceIDString(instdata.id, instdata.x, instdata.y)

                if firstTime
                    array_push(instanceList, instString)
                else
                {
                    var destroy = true
                    // Find the instance and destroy it if it doesn't exist
                    for (var k = 0, l = array_length(instanceList); k < l; k++)
                    {
                        var lstr = instanceList[k]
                        if (instString == lstr)
                        {
                            destroy = false
                            break;
                        }
                    }

                    if destroy
                    {
                        instance_destroy(inst, false)
                        continue;
                    }
                }

                inst.image_xscale = instdata.xscale
                inst.image_yscale = instdata.yscale

                for (var k = 0, l = array_length(instdata.variables); k < l; k++)
                {
                    var ivar = instdata.variables[k]

                    var varname = ivar[0]
                    var varvalue = ivar[1]
                    var vartype = ivar[2]

                    if (vartype == "default")
                        continue;

                    variable_instance_set(inst, varname, varvalue)
                }
            }
        }

        if !instance_exists(ob_player)
        {
            print("Setting current stage data")
            ob_stageManager.currentStage = CreateStageData()

            print("Doing stage intro")
            with (ob_stageManager)
            {
                resetStage()
                defaultStageInit()

                if !inReplayMode()
                    input_player().startRecording()
            }
        }
    }
}

// This needs to be here
static_get(new RoomLoader())