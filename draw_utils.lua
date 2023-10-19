local utils = {}

utils.round = function(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

utils.isPointInsidePolygon = function(point, polygon)
    local x, y = point[1], point[2]
    local isInside = false
    local n = #polygon

    for i = 1, n do
        local x1, y1 = polygon[i][1], polygon[i][2]
        local x2, y2 = polygon[(i % n) + 1][1], polygon[(i % n) + 1][2]

        if (y1 > y) ~= (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1 then
            isInside = not isInside
        end
    end

    return isInside
end


function utils.Color(red, green, blue, alpha)
    return {
        red / 255,
        green / 255,
        blue / 255,
        alpha or 1,
    }
end

utils.ColorBlack = utils.Color(0, 0, 0)
utils.ColorRed = utils.Color(255, 0, 0)
utils.ColorGreen = utils.Color(0, 255, 0)
utils.ColorBlue = utils.Color(0, 0, 255)
utils.ColorCyan = utils.Color(0, 255, 255)
utils.ColorPurple = utils.Color(255, 0, 255)
utils.ColorYellow = utils.Color(255, 255, 0)
utils.ColorWhite = utils.Color(255, 255, 255)

utils.ColorSelect = utils.Color(200, 200, 200, 0.9)

utils.Colors = {
    utils.ColorBlack,
    utils.ColorRed,
    utils.ColorGreen,
    utils.ColorBlue,
    utils.ColorCyan,
    utils.ColorPurple,
    utils.ColorYellow,
    utils.ColorWhite,
}

utils.randomColor = function()
    return utils.Colors[math.random(1, #utils.Colors)]
end

function utils.drawLine(x1, y1, x2, y2, width, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.setLineWidth(width or 1)
    love.graphics.line(x1, y1, x2, y2)
end

function utils.drawBox(x, y, w, h, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.rectangle("fill", x, y, w, h)
end

function utils.drawBoxOutline(x, y, w, h, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.rectangle("line", x, y, w, h)
end

function utils.drawCircle(x, y, r, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.circle("fill", x, y, r)
end

function utils.drawCircleOutline(x, y, r, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.circle("line", x, y, r)
end

function utils.drawPolygon(points, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.polygon("fill", points)
end

function utils.drawPolygonOutline(points, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.polygon("line", points)
end

function utils.debugInfo(frame, time, color)
    love.graphics.setColor(color or utils.ColorWhite)
    love.graphics.print("FRAME : " .. frame, 0, 0)
    love.graphics.print("TIME : " .. time, 0, 20)
    love.graphics.print("FPS : " .. love.timer.getFPS(), 0, 40)
end

return utils
