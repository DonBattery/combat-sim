local assets = {
    images = {},
    fonts = {},
    quads = {},
    cursors = {},
    factories = {},
}

assets.register_font = function(font_name, font_path, font_size)
    assets.fonts[font_name] = love.graphics.newFont(font_path, font_size)
end

assets.register_fonts = function(fonts)
    for font_name, font in pairs(fonts) do
        assets.register_font(font_name, font.path, font.size)
    end
end

assets.register_image = function(image_name, image_path)
    assets.images[image_name] = love.graphics.newImage(image_path)
end

assets.register_images = function(images)
    for image_name, image_path in pairs(images) do
        assets.register_image(image_name, image_path)
    end
end

assets.register_quad = function(image_name, quad_name, pos, size)
    assets.quads[quad_name] = love.graphics.newQuad(pos.x, pos.y, size.x, size.y,
        assets.images[image_name]:getDimensions())
end

assets.register_quads = function(quads)
    for quad_name, quad in pairs(quads) do
        assets.register_quad(quad.sprite_sheet, quad_name, quad.pos, quad.size)
    end
end

assets.register_box_factory = function(image_name, box_name, quad_pos, quad_size, corner_size)
    assets.register_quad(image_name, box_name .. "_top_left_corner", quad_pos, corner_size)
    assets.register_quad(image_name, box_name .. "_top_line", quad_pos + vector(corner_size.x, 0),
        vector(1, corner_size.y))
    assets.register_quad(image_name, box_name .. "_top_right_corner", quad_pos + vector(quad_size.x - corner_size.x, 0),
        corner_size)
    assets.register_quad(image_name, box_name .. "_left_line", quad_pos + vector(0, corner_size.y),
        vector(corner_size.x, 1))
    assets.register_quad(image_name, box_name .. "_right_line",
        quad_pos + vector(quad_size.x - corner_size.x, corner_size.y),
        vector(corner_size.x, 1))
    assets.register_quad(image_name, box_name .. "_bottom_left_corner", quad_pos + vector(0, quad_size.y - corner_size.y),
        corner_size)
    assets.register_quad(image_name, box_name .. "_bottom_line",
        quad_pos + vector(corner_size.x, quad_size.y - corner_size.y),
        vector(1, corner_size.y))
    assets.register_quad(image_name, box_name .. "_bottom_right_corner", quad_pos + quad_size - corner_size, corner_size)
    assets.register_quad(image_name, box_name .. "_center", quad_pos + corner_size, vector(1, 1))

    assets.factories[box_name] = function(size, color)
        local box = {
            size = size,
            color = color,
        }

        if box.size.x < corner_size.x * 2 + 1 or box.size.y < corner_size.y * 2 + 1 then
            error("Box size is too small. Required min width: " .. corner_size.x * 2 + 1 ..
                " Actual width: " .. box.size.x .. " Required min height: " .. corner_size.y * 2 + 1 ..
                " Actual height: " .. box.size.y)
        end

        box.sprite_batch = assets.NewSpriteBatch(image_name, 9)
        box.inner_width = box.size.x - corner_size.x * 2
        box.inner_height = box.size.y - corner_size.y * 2

        box.sprite_batch:add(box_name .. "_top_left_corner", vector(0, 0), vector(1, 1), box.color)
        box.sprite_batch:add(box_name .. "_top_line", vector(corner_size.x, 0), vector(box.inner_width, 1), box.color)
        box.sprite_batch:add(box_name .. "_top_right_corner", vector(box.size.x - corner_size.x, 0), vector(1, 1),
            box.color)
        box.sprite_batch:add(box_name .. "_left_line", vector(0, corner_size.y), vector(1, box.inner_height), box.color)
        box.sprite_batch:add(box_name .. "_right_line", vector(box.size.x - corner_size.x, corner_size.y),
            vector(1, box.inner_height), box.color)
        box.sprite_batch:add(box_name .. "_bottom_left_corner", vector(0, box.size.y - corner_size.y), vector(1, 1),
            box.color)
        box.sprite_batch:add(box_name .. "_bottom_line", vector(corner_size.x, box.size.y - corner_size.y),
            vector(box.inner_width, 1), box.color)
        box.sprite_batch:add(box_name .. "_bottom_right_corner", box.size - corner_size, vector(1, 1), box.color)
        box.sprite_batch:add(box_name .. "_center", corner_size, vector(box.inner_width, box.inner_height), box.color)

        box.draw_to = function(self, pos, color)
            self.sprite_batch:draw_to(pos, color)
        end

        return box
    end
end

assets.register_factories = function(factories)
    for factory_name, factory in pairs(factories) do
        assets.register_box_factory(factory.sprite_sheet, factory_name, factory.pos, factory.size, factory.corner_size)
    end
end

assets.register_cursors = function(cursor_data)
    for cursor_name, cursor in pairs(cursor_data) do
        local new_cursor = {
            states = {}
        }
        for state_name, state in pairs(cursor.states) do
            new_cursor.states[state_name] = assets.NewCursor(cursor.sprite_sheet, cursor_name .. "_" .. state_name,
                state.pos, state.size, state.hot_spot)
        end
        assets.cursors[cursor_name] = new_cursor
    end
end

assets.load_assets = function()
    assets.register_images(data.sprite_sheets)
    assets.register_quads(data.quads)
    assets.register_cursors(data.cursors)
    assets.register_fonts(data.fonts)
    assets.register_factories(data.box_factories)
end

-- Create a new Sprite object based on an image and a quad name. We can later use this Sprite to draw to the screen.
assets.NewSprite = function(image_name, quad_name, color)
    local new_sprite = {
        image = assets.images[image_name],
        quad = assets.quads[quad_name],
        color = color,
    }

    new_sprite.draw_to = function(self, pos, color)
        if color then
            love.graphics.setColor(color or self.color)
        elseif self.color then
            love.graphics.setColor(self.color)
        end
        love.graphics.draw(self.image, self.quad, pos.x, pos.y)
    end

    return new_sprite
end

assets.NewCursor = function(image_name, quad_name, pos, size, hotspot, color)
    assets.register_quad(image_name, quad_name, pos, size)

    local cursor = assets.NewSprite(image_name, quad_name, color)

    cursor.hotspot = hotspot or vector(0, 0)

    cursor.draw_to = function(self, pos, color)
        if color then
            love.graphics.setColor(color or self.color)
        elseif self.color then
            love.graphics.setColor(self.color)
        end
        love.graphics.draw(self.image, self.quad, pos.x - self.hotspot.x, pos.y - self.hotspot.y)
    end

    return cursor
end

assets.NewSpriteBatch = function(image_name, size)
    local new_sprite_batch = {
        batch = love.graphics.newSpriteBatch(assets.images[image_name], size),
    }

    new_sprite_batch.clear = function(self)
        self.batch:clear()
    end

    new_sprite_batch.add = function(self, quad_name, pos, scale, color)
        scale = scale or vector(1, 1)
        if color then
            self.batch:setColor(color[1], color[2], color[3], color[4])
        end
        self.batch:add(assets.quads[quad_name], pos.x, pos.y, 0, scale.x, scale.y)
    end

    new_sprite_batch.draw = function(self, color)
        if color then
            love.graphics.setColor(color)
        end
        love.graphics.draw(self.batch, 0, 0)
    end

    new_sprite_batch.draw_to = function(self, pos, color)
        if color then
            love.graphics.setColor(color)
        end
        love.graphics.draw(self.batch, pos.x, pos.y)
    end

    return new_sprite_batch
end

assets.default_font = function()
    return assets.fonts["default"]
end

return assets
