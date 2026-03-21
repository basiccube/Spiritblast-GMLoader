// Adventure will be moved into a new menu page
var adventureBtn = ds_list_find_value(mainPage, 0)
ds_list_delete(mainPage, 0)

customLevelsPage = pageCreate()
{
    var file = file_find_first("levels/*", fa_directory)
    while (file != "")
    {
        var lvlName = file
        var lvlRoom = "room"

        // Get level info from the level INI file
        var lvlIniPath = "levels/" + file + "/level.ini"
        if file_exists(lvlIniPath)
        {
            ini_open(lvlIniPath)
            lvlName = ini_read_string("Level", "Name", lvlName)
            lvlRoom = ini_read_string("Level", "FirstRoom", lvlRoom)
            ini_close()
        }

        var playMethod = method(static_get(RoomLoader), RoomLoader.PlayCustomLevel)
        var lvlBtn = new menuButton(lvlName, playMethod, [file, lvlRoom])
        ds_list_add(customLevelsPage, lvlBtn)

        file = file_find_next()
    }
    file_find_close()

    var backBtn = new menuButton("Back", popPage)
    ds_list_add(customLevelsPage, backBtn)
}

playPage = pageCreate(
    new menuItem("Choose."),
    new menuItem(""),
    adventureBtn,
    new menuButton("Custom Levels", changePage, customLevelsPage),
    new menuButton("Back", popPage)
)

ds_list_insert(mainPage, 0, new menuButton("Play!", changePage, playPage))