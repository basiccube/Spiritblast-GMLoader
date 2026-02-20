// Async - Networking

#macro NETDATA_TEST 0
#macro NETDATA_CLIENTDISCONNECT 1
#macro NETDATA_TESTROOM 2

if (ds_map_find_value(async_load, "type") != network_type_data)
	exit;

var createData = function(type)
{
	var buf = buffer_create(2, buffer_grow, 1)
	buffer_write(buf, buffer_u8, type)
	
	return buf;
}

var sendData = function(buffer)
{
	network_send_packet(rf_serversocket, buffer, buffer_get_size(buffer))
}

var socket = ds_map_find_value(async_load, "id")
var ip = ds_map_find_value(async_load, "ip")
var port = ds_map_find_value(async_load, "port")

var buffer = ds_map_find_value(async_load, "buffer")
var size = ds_map_find_value(async_load, "size")

var type = buffer_read(buffer, buffer_u8)
print("Data received, type", type)
switch type
{
	case NETDATA_TEST:
		var data = buffer_read(buffer, buffer_string)
		print(data)

		var testbuf = createData(NETDATA_TEST)
		sendData(testbuf)
		break

	case NETDATA_CLIENTDISCONNECT:
		print("Stopping connection as requested by server...")
		rf_stopConnection()
		break

	case NETDATA_TESTROOM:
		var b64str = buffer_read(buffer, buffer_string)
		var jsonstr = base64_decode(b64str)

		RoomLoader.roomData = json_parse(jsonstr)
        RoomLoader.currentRoom = "rf_testRoom"

		RoomLoader.levelStarted = false
        RoomLoader.playingCustomLevel = true
        RoomLoader.ClearInstanceMap()

        room_set_width(rm_template_room, RoomLoader.roomData.roomInfo.width)
        room_set_height(rm_template_room, RoomLoader.roomData.roomInfo.height)
		
        room_goto(rm_template_room)
		break
}