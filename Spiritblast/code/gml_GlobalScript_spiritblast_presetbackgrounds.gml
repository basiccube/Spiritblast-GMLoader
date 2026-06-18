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
}

static_get(new PresetBackgrounds())