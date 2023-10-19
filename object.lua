local draw_utils = require("draw_utils")

local gameObject = {}

gameObject.New = function(x, y, w, h, image)
    local gameObject = {}

    gameObject.x = x or 0
    gameObject.y = y or 0
    gameObject.w = w or 16
    gameObject.h = h or 16
    gameObject.image = image

    gameObject.color = draw_utils.randomColor()

    gameObject.draw = function(debug)
        if gameObject.image then
            love.graphics.draw(
                gameObject.image,
                gameObject.x,
                gameObject.y
            )
        end
        if debug then
            draw_utils.drawBoxOutline(
                gameObject.x,
                gameObject.y,
                gameObject.w,
                gameObject.h,
                gameObject.color
            )
        end
    end

    return gameObject
end

return gameObject
