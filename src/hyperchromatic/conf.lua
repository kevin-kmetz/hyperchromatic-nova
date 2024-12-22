-- hyperchromatic/conf.lua

function love.conf(settings)
    -- Core settings
    settings.version = "11.5"
    settings.identy = "hyperchromatic_nova_savedata"

    -- Window settings
    settings.window.title = "HyperChromatic-Nova v0.1.0-dev"
    settings.window.width = 800
    settings.window.height = 600
    settings.window.resizable = false
    settings.window.fullscreen = false
end
