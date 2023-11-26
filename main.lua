-- The Löve 2D framework https://love2d.org/
_G.love      = require("love")

-- github.com/Ulydev/push (for scaling the window and fullscreen mode)
_G.push      = require("lib.push")

-- github.com/novemberisms/brinevector (for vector math)
_G.vector    = require("lib.brinevector")

_G.data      = require("data")

_G.draw      = require("src.draw")

_G.utils     = require("src.utils")

_G.assets    = require("src.assets")

_G.grid      = require("src.grid")

_G.editor    = require("src.editor")

_G.ui        = require("src.ui")

_G.editor_ui = require("src.editor_ui")

-- Global debug functions --
_G.dump      = function(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

_G.dumps     = function(o)
    print(dump(o))
end
-------------------------

function love.load()
    math.randomseed(os.time())

    assets.load_assets()

    _G.frame        = 0

    _G.time         = 0

    _G.mouse_pos    = vector(0, 0)

    _G.debug        = false

    _G.debugger     = draw.NewDebugger(vector(0, 0), draw.ColorTransparentGray, draw.ColorWhite)

    _G.drawing_time = ""

    _G.app          = editor.NewEditor()

    app.grid:init({
        quad_name = "tile",
    }, {
        green_selector = assets.NewSprite("tile_set", "green_selector_tile"),
        blue_selector = assets.NewSprite("tile_set", "blue_selector_tile"),
        yellow_selector = assets.NewSprite("tile_set", "yellow_selector_tile"),
    })

    -- Graphics options
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineWidth(1)

    -- Hide the mouse cursor
    love.mouse.setVisible(false)

    -- set up push for window scaling
    local window_width, window_height = love.graphics.getDimensions()

    push:setupScreen(data.screen.width, data.screen.height, window_width, window_height, {
        fullscreen = false,
        resizable = true,
        highdpi = false,
        canvas = true,
        pixelperfect = false,
    })

    print("Memory In Use", collectgarbage("count"))
end

-- pass keyboard events to the editor
function love.keypressed(key)
    if key == "d" then
        debug = not debug
    end
    app:keypressed(key)
end

function love.keyreleased(key)
    app:keyreleased(key)
end

-- pass mouse events to the editor
function love.mousepressed(x, y, button)
    app:mousepressed(button)
end

function love.mousereleased(x, y, button)
    app:mousereleased(button)
end

function love.wheelmoved(x, y)
    app:wheelmoved(x, y)
end

-- when the window is resized we pass the new dimensions to push so it knows how to scale
-- called by Löve on window resized event
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    -- update the frame and time counters
    _G.frame = _G.frame + 1
    _G.time = _G.time + dt

    -- update the mouse position
    local mouse_x, mouse_y = love.mouse.getPosition()
    local push_mouse_x, push_mouse_y = push:toGame(mouse_x, mouse_y)
    if push_mouse_x then
        mouse_pos.x = utils.round(push_mouse_x)
    end
    if push_mouse_y then
        mouse_pos.y = utils.round(push_mouse_y)
    end

    -- update the editor
    app:update(dt, mouse_pos)

    -- update the debug information
    debugger:update_infos({
        {
            name = "FPS",
            value = love.timer.getFPS(),
        },
        {
            name = "Frame",
            value = frame,
        },
        {
            name = "DrawCalls",
            value = app.grid.draw_calls,
        },
        {
            name = "DrawTime",
            value = _G.drawing_time,
        },
        {
            name = "Mouse",
            value = mouse_pos.x .. ":" .. mouse_pos.y,
        },
        {
            name = "Scroll Direction",
            value = app.mouse.scroll_direction.x .. ":" .. app.mouse.scroll_direction.y,
        },
        {
            name = "Editor Offset",
            value = app.grid.rounded_offset.x .. ":" .. app.grid.rounded_offset.y,
        },
        {
            name = "Selected Cell",
            value = app.grid.selected_cell_pos or "No Selected",
        },
        {
            name = "Centered Cell",
            value = app.grid.centered_cell_pos or "No Centered",
        },
        {
            name = "Active Layer",
            value = app.grid.active_layer,
        },
        {
            name = "Search Box",
            value = app.grid.layer_search_box.x,
        },
        {
            name = "Manhattan Distance",
            value = app.grid.current_distance,
        },
    })
end

function love.draw()
    local current_time = love.timer.getTime()

    -- clear the screen
    love.graphics.clear(0.1, 0.1, 0.1, 1)

    -- start the auto-scaler
    push:apply("start")

    -- draw the editor
    app:draw()

    -- draw the debug information
    if debug then
        debugger:draw()
    end

    -- stop the auto-scaler
    push:apply("end")

    local drawing_time = love.timer.getTime() - current_time
    local _, _, sec, millisec = utils.time_from_milliseconds(drawing_time)
    _G.drawing_time = sec .. ":" .. utils.limit_digits(millisec, 5)
end
