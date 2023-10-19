local ui = {}

local draw_utils = require("draw_utils")

local background_img = love.graphics.newImage("assets/grapics/ui2.png")

ui.New = function(screenHeight, screenWidth, cellSize, debug)
    local ui = {
        screenHeight = screenHeight,
        screenWidth = screenWidth,
        cellSize = cellSize or 16,
        debug = debug or false,
        boundingBox = {
            x = 0,
            y = 0,
            w = screenWidth,
            h = screenHeight,
        },
        top_left_panel = {
            0,
            0,
            draw_utils.round(screenWidth / 2),
            0,
            draw_utils.round(screenWidth / 2),
            draw_utils.round(cellSize * 2),
            draw_utils.round(cellSize * 1.5),
            draw_utils.round(screenHeight / 2),
            0,
            draw_utils.round(screenHeight / 2),
        },

        mouse = {
            x = 0,
            y = 0,
        },

        tools = {

        }
    }

    ui.update = function(self, mouseX, mouseY)
        ui.mouse.x = mouseX
        ui.mouse.y = mouseY
    end

    ui.draw = function(self)
        -- if self.debug then
        --     draw_utils.drawBoxOutline(self.boundingBox.x, self.boundingBox.y, self.boundingBox.w, self.boundingBox.h,
        --         draw_utils.ColorRed)
        --     draw_utils.drawPolygonOutline(self.top_left_panel, draw_utils.ColorRed)
        -- end
        love.graphics.setColor(draw_utils.ColorWhite)
        love.graphics.draw(background_img, 0, 0)
    end

    return ui
end

return ui
