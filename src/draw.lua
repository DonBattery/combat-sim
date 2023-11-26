local draw = {}

function draw.Color(red, green, blue, alpha)
    return {
        red / 255,
        green / 255,
        blue / 255,
        alpha or 1,
    }
end

draw.ColorWhite = draw.Color(255, 255, 255)
draw.ColorSemiTransparentWhite = draw.Color(250, 250, 250, 0.9)
draw.ColorBlack = draw.Color(0, 0, 0)
draw.ColorGray = draw.Color(128, 128, 128)
draw.ColorTransparentGray = draw.Color(128, 128, 128, 0.5)
draw.ColorDarkGray = draw.Color(64, 64, 64)
draw.ColorTransparentDarkGray = draw.Color(64, 64, 64, 0.8)
draw.ColorLightGray = draw.Color(192, 192, 192)
draw.ColorTransparentLightGray = draw.Color(192, 192, 192, 0.5)
draw.ColorSemiTransparentLightGray = draw.Color(220, 220, 220, 0.85)
draw.ColorRed = draw.Color(255, 0, 0)
draw.ColorDarkRed = draw.Color(128, 0, 0)
draw.ColorGreen = draw.Color(0, 255, 0)
draw.ColorDarkGreen = draw.Color(0, 128, 0)
draw.ColorBlue = draw.Color(0, 0, 255)
draw.ColorDarkBlue = draw.Color(0, 0, 128)
draw.ColorCyan = draw.Color(0, 255, 255)
draw.ColorPurple = draw.Color(255, 0, 255)
draw.ColorYellow = draw.Color(255, 255, 0)

draw.ColorSelect = draw.Color(200, 200, 200, 0.9)
draw.ColorInactive = draw.Color(64, 64, 64, 0.9)

draw.Colors = {
    draw.ColorBlack,
    draw.ColorRed,
    draw.ColorGreen,
    draw.ColorBlue,
    draw.ColorCyan,
    draw.ColorPurple,
    draw.ColorYellow,
    draw.ColorWhite,
}

draw.random_color = function()
    return draw.Colors[math.random(1, #draw.Colors)]
end

function draw.line(point_a, point_b, width, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.setLineWidth(width or 1)
    love.graphics.line(point_a.x, point_a.y, point_b.x, point_b.y)
end

function draw.box(corner, dimensions, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.rectangle("fill", corner.x, corner.y, dimensions.x, dimensions.y)
end

function draw.box_outline(corner, dimensions, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.rectangle("line", corner.x, corner.y, dimensions.x, dimensions.y)
end

function draw.rounded_box_with_outline(corner, dimensions, border_width, border_radius, color, outline_color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.rectangle("fill", corner.x, corner.y, dimensions.x, dimensions.y, border_radius or 0,
        border_radius or 0)

    love.graphics.setColor(outline_color or draw.ColorWhite)
    love.graphics.setLineWidth(border_width or 1)
    love.graphics.rectangle("line", corner.x, corner.y, dimensions.x, dimensions.y, border_radius or 0,
        border_radius or 0)
end

function draw.rounded_box_outline(corner, dimensions, border_width, border_radius, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.setLineWidth(border_width or 1)
    love.graphics.rectangle("line", corner.x, corner.y, dimensions.x, dimensions.y, border_radius or 0)
end

function draw.circle(center, radius, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.circle("fill", center.x, center.y, radius)
end

function draw.ellipse(center, dimensions, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.ellipse("fill", center.x, center.y, dimensions.x, dimensions.y)
end

function draw.ellipse_outline(center, dimensions, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.ellipse("line", center.x, center.y, dimensions.x, dimensions.y)
end

function draw.circle_outline(center, radius, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.circle("line", center.x, center.y, radius)
end

function draw.polygon(points, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.polygon("fill", points)
end

function draw.polygon_outline(points, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.polygon("line", points)
end

function draw.debug_info(info, position, color)
    if not position then
        position = vector(0, 0)
    end
    local draw_x = position.x or 0
    local draw_y = position.y or 0
    love.graphics.setColor(color or draw.ColorWhite)
    for key, value in pairs(info) do
        love.graphics.print(key .. " : " .. value, draw_x, draw_y)
        draw_y = draw_y + 20
    end
end

function draw.text(text, position, color)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.print(text, position.x, position.y)
end

function draw.formatted_text(text, position, color, allignment)
    love.graphics.setColor(color or draw.ColorWhite)
    love.graphics.printf(text, position.x, position.y, allignment or "left")
end

function draw.NewDebugger(position, background_color, text_color, font)
    local new_debugger = {
        position = position or vector(0, 0),
        background_color = background_color or draw.ColorBlack,
        text_color = text_color or draw.ColorWhite,
        font = font or "default",
        info = {},
    }

    new_debugger.add_info = function(self, info)
        table.insert(self.info, info)
    end

    new_debugger.add_infos = function(self, infos)
        for _, info in ipairs(infos) do
            self:add_info(info)
        end
    end

    new_debugger.update_info = function(self, info)
        local found_info = false
        for _, v in ipairs(self.info) do
            if v.name == info.name then
                v.value = info.value
                found_info = true
            end
        end
        if not found_info then
            self:add_info(info)
        end
    end

    new_debugger.update_infos = function(self, infos)
        for _, info in ipairs(infos) do
            self:update_info(info)
        end
    end

    new_debugger.draw = function(self)
        local draw_x = self.position.x
        local draw_y = self.position.y
        love.graphics.setColor(self.background_color)
        love.graphics.rectangle("fill", draw_x, draw_y, 120, 11 * #self.info)
        love.graphics.setColor(self.text_color)
        love.graphics.setFont(assets.fonts[self.font])
        for _, v in ipairs(self.info) do
            love.graphics.print(v.name .. " : " .. v.value, draw_x, draw_y)
            draw_y = draw_y + 10
        end
    end

    return new_debugger
end

return draw
