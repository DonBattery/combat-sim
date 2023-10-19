local utils = require("utils")
local draw_utils = require("draw_utils")
local tile = require("tile")

-- These are the four numbers that define the transform, i hat and j hat
local i_x = 1
local i_y = 0.5
local j_x = -1
local j_y = 0.5

local default_tile_size = 24
local default_game_size = 10

local world = {}

function world.New(screen_width, screen_height, tile_width, tile_height, game_size, debug)
    local world = {
        screen_width = screen_width or love.graphics.getWidth(),
        screen_height = screen_height or love.graphics.getHeight(),
        tile_height = tile_height or default_tile_size,
        tile_width = tile_width or default_tile_size,
        game_size = game_size or default_game_size,
        debug = debug or false,

        calculator = utils.NewIsometricCalculator(screen_width, screen_height, 0, 0, tile_width, tile_height, game_size),

        map = {},
        boundingBox = {
            x = 0,
            y = 0,
            w = game_size * tile_width,
            h = game_size * tile_height / 2,
        },
        selection = {
            x = 1,
            y = 1,
            size = 1
        },
        previous_selection = {
            x = 1,
            y = 1,
            size = 1
        },
        mouse = {
            x = 0,
            y = 0,
        },
        -- floor_type = tile.random_floor_type()
        floor_type = "blue_floor"
    }

    -- local odd_floor_type = "blue_floor"
    -- local even_floor_type = "dark_blue_floor"

    for row = 1, world.game_size, 1 do
        world.map[row] = {}
        for col = 1, world.game_size, 1 do
            -- local floor_type = ""
            -- if ((row % 2 == 0) and (col % 2 == 1)) or ((row % 2 == 1) and (col % 2 == 0)) then
            --     floor_type = even_floor_type
            -- else
            --     floor_type = odd_floor_type
            -- end
            -- world.map[row][col] = tile.New(floor_type)
            world.map[row][col] = tile.New(world.floor_type)
        end
    end

    -- world.map[1][1]:setObject("bottle_1")
    -- world.map[3][4]:setObject("bottle_2")
    -- world.map[3][5]:setObject("bottle_2")
    -- world.map[4][4]:setObject("bottle_2")
    -- world.map[4][5]:setObject("bottle_2")
    -- world.map[5][6]:setObject("frog_1")
    -- world.map[7][7]:setObject("frog_1")
    -- world.map[2][1].type = "red_floor"
    -- world.map[3][1].type = "red_floor"
    -- world.map[4][1].type = "red_floor"

    world.toggleDebug = function(self)
        self.debug = not self.debug
    end

    world.mouseDown = function(self, button)
        print("Mouse clicked on tileX " ..
            self.selection.x .. " tileY " .. self.selection.y .. " size " .. self.selection.size .. " button " .. button)
        if button == 1 then
            self:riseTiles(self.selection.x, self.selection.y, self.selection.size)
        elseif button == 2 then
            self:lowerTiles(self.selection.x, self.selection.y, self.selection.size)
        end
    end

    world.mouseUp = function(self, button)

    end

    world.increaseSelectionSize = function(self)
        if self.selection.size < self.game_size then
            self.selection.size = self.selection.size + 1
        end
    end

    world.decraseSelectionSize = function(self)
        if self.selection.size > 1 then
            self.selection.size = self.selection.size - 1
        end
    end

    world.riseTile = function(self, x, y)
        print("Rising tileX " .. x .. " tileY " .. y)

        tile = self.map[y][x]
        if tile then
            if tile.type == "empty" then
                tile.type = self.floor_type
                tile.height = 0
                return
            end
            if tile.height < 5 then
                tile.height = tile.height + 1
            end
        end
    end

    world.riseTiles = function(self, x, y, size)
        local tire_coords = self:getTileCoords(x, y, size)
        for _, tile_pos in ipairs(tire_coords) do
            self:riseTile(tile_pos.x, tile_pos.y)
        end
    end

    world.lowerTile = function(self, x, y)
        tile = self.map[y][x]
        if tile then
            if tile.height > 0 then
                tile.height = tile.height - 1
            else
                tile.type = "empty"
                tile.height = 0
            end
        end
    end

    world.lowerTiles = function(self, x, y, size)
        local tire_coords = self:getTileCoords(x, y, size)
        for _, tile_pos in ipairs(tire_coords) do
            self:lowerTile(tile_pos.x, tile_pos.y)
        end
    end

    world.getTileCoords = function(self, x, y, selection_size)
        local coords = {}
        for row = 1, selection_size, 1 do
            for col = 1, selection_size, 1 do
                local posX = x + col - 1
                local posY = y + row - 1
                if posX > 0 and posX <= self.game_size and posY > 0 and posY <= self.game_size then
                    local tile_pos = {
                        x = posX,
                        y = posY
                    }
                    table.insert(coords, tile_pos)
                end
            end
        end
        return coords
    end

    world.getSelectedTiles = function(self, x, y, size)
        local tiles = {}
        local coords = self:getTileCoords(x, y, size)
        for _, tile_pos in ipairs(coords) do
            local tile = self.map[tile_pos.y][tile_pos.x]
            if tile then
                table.insert(tiles, tile)
            end
        end
        return tiles
    end

    -- world.invert_matrix = function(self, a, b, c, d)
    --     -- Determinant
    --     local det = (1 / (a * d - b * c));

    --     return {
    --         a = det * d,
    --         b = det * -b,
    --         c = det * -c,
    --         d = det * a,
    --     }
    -- end

    -- world.to_grid_coordinate = function(self, screenX, screenY)
    --     local w = self.cellSize;
    --     local h = self.cellSize;
    --     screenX = screenX +
    --         (self.cellSize / 2) -
    --         (self.screenWidth / 2)
    --     screenY = screenY -
    --         (self.screenHeight / 2) +
    --         (self.gameSize * self.cellSize / 4)

    --     local a = i_x * 0.5 * w;
    --     local b = j_x * 0.5 * w;
    --     local c = i_y * 0.5 * h;
    --     local d = j_y * 0.5 * h;

    --     local inv = self:invert_matrix(a, b, c, d);

    --     return {
    --         x = draw_utils.round(screenX * inv.a + screenY * inv.b),
    --         y = draw_utils.round(screenX * inv.c + screenY * inv.d) + 1,
    --     }
    -- end

    -- world.to_screen_coordinate = function(self, tileX, tileY)
    --     -- Accounting for sprite size
    --     return {
    --         x = (tileX * i_x * 0.5 * self.cellSize + tileY * j_x * 0.5 * self.cellSize) -
    --             (self.cellSize / 2) +
    --             (self.screenWidth / 2),

    --         y = (tileX * i_y * 0.5 * self.cellSize + tileY * j_y * 0.5 * self.cellSize) +
    --             (self.screenHeight / 2) -
    --             (self.gameSize * self.cellSize / 4),
    --     }
    -- end

    world.update = function(self, dt, mouseX, mouseY)
        if mouseX then
            self.mouse.x = mouseX
        end
        if mouseY then
            self.mouse.y = mouseY
        end

        local pos = self.calculator:to_grid_coordinate(self.mouse.x, self.mouse.y)
        if pos.x < 1 then
            pos.x = 1
        end
        if pos.x > self.game_size then
            pos.x = self.game_size
        end
        if pos.y < 1 then
            pos.y = 1
        end
        if pos.y > self.game_size then
            pos.y = self.game_size
        end
        self.selection.x = pos.x
        self.selection.y = pos.y
        if self.selection.x ~= self.previous_selection.x or
            self.selection.y ~= self.previous_selection.y or
            self.selection.size ~= self.previous_selection.size then
            local previously_selected_tiles = self:getSelectedTiles(self.previous_selection.x, self.previous_selection
                .y, self.previous_selection.size)
            for _, tile in ipairs(previously_selected_tiles) do
                tile:removeSelection("tile_outline")
            end
            local selected_tiles = self:getSelectedTiles(self.selection.x, self.selection.y, self.selection.size)
            for _, tile in ipairs(selected_tiles) do
                tile:addSelection("tile_outline")
            end
            self.previous_selection.x = self.selection.x
            self.previous_selection.y = self.selection.y
            self.previous_selection.size = self.selection.size
        end
    end

    world.drawTiles = function(self)
        for row = 1, self.game_size, 1 do
            for col = 1, self.game_size, 1 do
                local selected = false
                local coords = self.calculator:to_screen_coordinate(col - 1, row - 1)
                local tile = self.map[row][col]
                if tile then
                    tile:draw(coords.x, coords.y, draw_utils.ColorWhite, self.debug)
                    -- if self.debug then
                    --     local box_color = draw_utils.ColorWhite
                    --     if selected then
                    --         box_color = draw_utils.ColorCyan
                    --     end
                    --     draw_utils.drawBoxOutline(
                    --         coords.x,
                    --         coords.y - tile.height,
                    --         self.cellSize,
                    --         self.cellSize,
                    --         box_color
                    --     )
                    --     love.graphics.setColor(draw_utils.ColorWhite)
                    -- end
                    -- if selected then
                    --     tile:draw(coords.x, coords.y, draw_utils.ColorSelect)
                    --     love.graphics.setColor(draw_utils.ColorWhite)
                    -- else
                    --     tile:draw(coords.x, coords.y)
                    -- end
                end
            end
        end
    end

    world.drawOutlines = function(self)
        -- bounding box outline
        draw_utils.drawBoxOutline(
            0,
            0,
            self.screen_width - 1,
            self.screen_height - 1
        )

        -- screen horizontal and vertical axis
        draw_utils.drawLine(0, draw_utils.round(self.screen_height / 2), self.screen_width - 1,
            draw_utils.round(self.screen_height / 2))
        draw_utils.drawLine(draw_utils.round(self.screen_width / 2), 0, draw_utils.round(self.screen_width / 2),
            self.screen_height - 1)

        -- mouse position
        draw_utils.drawCircleOutline(self.mouse.x, self.mouse.y, 5, draw_utils.ColorRed)
    end

    world.draw = function(self)
        self:drawTiles()

        if self.debug then
            self:drawOutlines()
        end
    end

    return world
end

return world
