// Script solely for containing preset backgrounds for the room loader

function PresetBackgrounds() constructor
{
    static backgrounds = ds_map_create()

    static Activate = function(name)
    {
        var bg = ds_map_find_value(backgrounds, name)
        if is_undefined(bg)
            exit;
        
        // Delete the gray background since it'll be on top of the actual background
        if layer_exists("Background")
            layer_destroy("Background")
        
        bg()
    }

    static Add = function(name, func)
    { ds_map_set(backgrounds, name, func); }

    Add("City Rooftops", function()
    {
        var ev1 = layer_create(1600, "EV1")
        var ev1bg = layer_background_create(ev1, sp_EV_cityRooftops1)
        layer_background_htiled(ev1bg, true)
        layer_background_vtiled(ev1bg, true)

        var ev1clouds = layer_create(1500, "EV1clouds")
        var ev1cloudsbg = layer_background_create(ev1clouds, sp_EV_cityRooftops1_clouds)

        var ev2 = layer_create(1400, "EV2")
        var ev2bg = layer_background_create(ev2, sp_EV_cityRooftops2)
        layer_background_htiled(ev2bg, true)
        layer_background_vtiled(ev2bg, true)

        global.camera_main.setLayerParallax("EV1", 1, "EV1clouds", 1, "EV2", 0.75, "Trees", -0.25)
        global.camera_main.setLayerParallaxY("EV2", 0.75, "Trees", 0)
        global.camera_main.layerParallaxSetScrollSpeed("EV1clouds", 0.15)
        global.camera_main.layerParallaxYAdjustForClamp("EV2")
        
        with (global.layer_effects_manager.bgColorData)
        {
            tintAmount = 0.6
            tint = 35980
            brightness = 0.1
            blackVal = 17974
        }
    })

    Add("City Underground", function()
    {
        var ev1 = layer_create(2400, "EV1")
        var ev1bg = layer_background_create(ev1, sp_EV_cityUnderground1)
        layer_background_htiled(ev1bg, true)

        var ev2 = layer_create(2300, "EV2")
        var ev2bg = layer_background_create(ev2, sp_EV_cityUnderground2)
        layer_background_htiled(ev2bg, true)

        global.camera_main.setLayerParallax("EV1", 0.875, "EV2", 0.75)
        with (global.layer_effects_manager.bgColorData)
        {
            tintAmount = 0.6
            tint = 2104320
        }
    })

    Add("Casino", function()
    {
        var ev1 = layer_create(3800, "EV1")
        var ev1bg = layer_background_create(ev1, sp_EV_casino1)
        layer_background_htiled(ev1bg, true)
        layer_background_vtiled(ev1bg, true)

        var ev2 = layer_create(3700, "EV2")
        var ev2bg = layer_background_create(ev2, sp_EV_casino2)
        layer_background_htiled(ev2bg, true)
        layer_background_vtiled(ev2bg, true)

        global.camera_main.setLayerParallax("EV1", 0.75, "EV2", 0.5, "Trees", 0.25)
		global.camera_main.setLayerParallax("EV1", 0.75, "EV2", 0.5, "Trees", 0.25)
    })

    Add("Casino Hell", function()
    {
        var evsky = layer_create(900, "EVsky")
        var evskybg = layer_background_create(evsky, sp_EV_gardensTest_sky)
        layer_background_htiled(evskybg, true)
        layer_background_vtiled(evskybg, true)

        var evclouds = layer_create(800, "EVclouds")
        instance_create_layer(0, 0, evclouds, ob_EV_gardensTest_clouds)

        var evcastle = layer_create(700, "EVcastle")
        var evcastlebg = layer_background_create(evcastle, sp_EV_gardensTest_castle)

        var evfog = layer_create(600, "EVfog")
        instance_create_layer(0, 0, evfog, ob_EV_gardensTest_fog)
        instance_create_layer(0, 0, evfog, ob_EV_gardensClouds)

        global.camera_main.setLayerParallax("EVsky", 1, "EVclouds", 1, "EVcastle", 1, "EVfog", 1)
        with (global.layer_effects_manager.bgColorData)
        {
            tintAmount = 0.3
            tint = 10027110
            blackVal = 2490406
        }
    })
}

static_get(new PresetBackgrounds())