debugPage = pageCreate(
    new menuToggle("Debug Overlay", global.sb_settings.debug.debugOverlay, global.sb_settings.debug, "debugOverlay"),
    new menuToggle("Debug Controls", global.sb_settings.debug.debugControls, global.sb_settings.debug, "debugControls"),
    new menuToggle("Debug Output Window (Restart)", global.sb_settings.debug.debugOutput, global.sb_settings.debug, "debugOutput"),
    new menuToggle("Skip Splash Screens", global.sb_settings.debug.skipSplash, global.sb_settings.debug, "skipSplash"),
    new menuButton("Back", popPage)
)

var debugPageBtn = new menuButton("Debug", changePage, debugPage)
ds_list_insert(mainPage, 5, debugPageBtn)

// For some reason creating a page in the options menu also changes the current page to it
changePage(mainPage, false)

// add borderless fullscreen toggle
var bFullscreenToggle = new menuToggle("Borderless Fullscreen", global.sb_settings.video.borderlessFullscreen)
with (bFullscreenToggle)
{
    update = function()
    {
        global.sb_settings.video.borderlessFullscreen = value
        ds_map_find_value(global.sb_builtinFunctions, "window_enable_borderless_fullscreen")(value)
    }
}
ds_list_insert(displayPage, 2, bFullscreenToggle)