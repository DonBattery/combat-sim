local draw_utils = require("draw_utils")

local tile_set = love.graphics.newImage("assets/grapics/tile_set_24x24.png")

local tile_size = 24

local function Selection(name, type, color)
    local selection = {
        name = name or "debug",
        type = type or "bounding_box",
        color = color or draw_utils.ColorSelect,
    }

    selection.draw = function(self, x, y)
        if self.type == "bounding_box" then
            draw_utils.drawBoxOutline(x, y, tile_size, tile_size, self.color)
        end
        if self.type == "tile" then
            draw_utils.drawPolygon(
                {
                    x, draw_utils.round(y + tile_size / 4),
                    draw_utils.round(x + tile_size / 2), y,
                    x + tile_size, draw_utils.round(y + tile_size / 4),
                    draw_utils.round(x + tile_size / 2), draw_utils.round(y + tile_size / 2),
                },
                self.color
            )
        end
        if self.type == "tile_outline" then
            draw_utils.drawPolygonOutline(
                {
                    x, draw_utils.round(y + tile_size / 4),
                    draw_utils.round(x + tile_size / 2), y,
                    x + tile_size, draw_utils.round(y + tile_size / 4),
                    draw_utils.round(x + tile_size / 2), draw_utils.round(y + tile_size / 2),
                },
                self.color
            )
        end
    end

    return selection
end

local selections = {
    debug = Selection(),
    tile = Selection("tile", "tile", draw_utils.ColorSelect),
    tile_outline = Selection("tile_outline", "tile_outline", draw_utils.ColorRed),
}

local tile = {}

local floor_types = {
    "red_floor",
    "green_floor",
    "blue_floor",
    "purple_floor",
}

tile.random_floor_type = function()
    return floor_types[math.random(1, #floor_types)]
end

local function get_quad(tileX, tileY)
    return love.graphics.newQuad(tileX * tile_size, tileY * tile_size, tile_size, tile_size, tile_set)
end

local tile_quads = {
    empty = get_quad(0, 0),
    -- red_floor = get_quad(1, 0),
    -- green_floor = get_quad(2, 0),
    -- blue_floor = get_quad(3, 0),
    -- dark_blue_floor = get_quad(3, 1),
    -- purple_floor = get_quad(4, 0),
    blue_floor = get_quad(1, 0)
}

local object_quads = {
    bottle_1 = get_quad(0, 2),
    bottle_2 = get_quad(1, 2),
    monster_1 = get_quad(2, 2),
    frog_1 = get_quad(3, 2),
}

tile.New = function(type, height, object)
    local tile = {
        type = type,
        height = height or 0,
        object = object or nil,
        selections = {}
    }

    tile.setType = function(self, type)
        self.type = type
    end

    tile.setObject = function(self, object)
        self.object = object
    end

    tile.clearObject = function(self)
        self.object = nil
    end

    tile.setHeight = function(self, height)
        self.height = height
    end

    tile.addSelection = function(self, selection)
        table.insert(self.selections, selections[selection])
    end

    tile.removeSelection = function(self, selection)
        for i, v in ipairs(self.selections) do
            if v.name == selection then
                table.remove(self.selections, i)
                break
            end
        end
    end

    tile.clearSelections = function(self)
        self.selections = {}
    end

    tile.draw = function(self, x, y, color, debug)
        if color then
            love.graphics.setColor(color)
        end

        if self.type ~= "empty" then
            love.graphics.draw(tile_set, tile_quads[tile.type], x, y - tile.height)
        end

        for i, v in ipairs(self.selections) do
            v:draw(x, y - tile.height)
        end

        if debug then
            selections.debug:draw(x, y - tile.height)
        end

        if self.type ~= "empty" then
            if self.object then
                love.graphics.setColor(draw_utils.ColorWhite)
                love.graphics.draw(tile_set, object_quads[self.object], x, y - tile.height - tile_size / 4)
            end
        end
    end

    return tile
end

return tile
