_G.love  = require("love")

-- github.com/Ulydev/push (for scaling the window and fullscreen mode)
_G.push  = require("lib/push")

_G.utils = require("draw_utils")

_G.world = require("world")

_G.ui    = require("ui")

math.randomseed(os.time())

local tile_width = 24
local tile_height = 28
local world_size = 18
local game_window_width = 480
local game_window_height = 270

function NewGame(debug)
    _G.game = world.New(game_window_width, game_window_height, tile_width, tile_height, world_size, debug)
end

function love.load()
    _G.frame = 0
    _G.time = 0
    _G.debug = false

    -- Drawing constants
    _G.screenWidth = game_window_width
    _G.screenHeight = game_window_height

    NewGame(false)

    -- _G.game_ui = ui.New(screenHeight, screenWidth, tile_size, true)

    -- Graphics options
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineWidth(1)

    -- set up push for window scaling
    local windowWidth, windowHeight = love.graphics.getDimensions()
    -- windowWidth, windowHeight = windowWidth * .75, windowHeight * .75
    push:setupScreen(screenWidth, screenHeight, windowWidth, windowHeight, {
        fullscreen = false,
        resizable = true,
        highdpi = false,
        canvas = true,
        pixelperfect = false,
    })
end

-- handle ESC and the F-keys separately (called by Löve on key pressed event)
function love.keypressed(key)
    -- ESC exits from the game
    if key == "escape" then
        love.event.quit()
    end

    -- F1 toggles fullscreen
    if key == "f1" then
        push:switchFullscreen()
    end


    if key == "f2" then
        debug = not debug
    end

    if key == "f3" then
        game:toggleDebug()
    end

    if key == "f4" then
        NewGame(game.debug)
    end

    -- if key == "," then
    --     game:riseTile()
    -- end

    -- if key == "." then
    --     game:lowerTile()
    -- end

    if key == "[" then
        game:decraseSelectionSize()
    end

    if key == "]" then
        game:increaseSelectionSize()
    end

    -- F3 toggles the sound effects
    --  if key == "f3" then
    --     sound.toggleFX()
    --  end
end

local function getRelativeMousePosition()
    local mouseX, mouseY = love.mouse.getPosition()
    local pushMouseX, pushMouseY = push:toGame(mouseX, mouseY)
    return pushMouseX, pushMouseY
end

function love.mousepressed(x, y, button)
    game:mouseDown(button)
end

function love.mousereleased(x, y, button)
    game:mouseUp(button)
end

-- when the window is resized we pass the new dimensions to push so it knows how to scale
-- called by Löve on window resized event
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    frame = frame + 1
    time = time + dt

    local mouseX, mouseY = getRelativeMousePosition()
    game:update(dt, mouseX, mouseY)
    -- game_ui:update(mouseX, mouseY)
end

function love.draw()
    -- start the auto-scaler
    push:apply("start")

    -- draw the game
    game:draw()

    -- draw the UI
    -- game_ui:draw()

    -- draw the debug information
    if debug then
        utils.debugInfo(frame, time)
    end

    -- stop the auto-scaler
    push:apply("end")
end
