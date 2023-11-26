local function to_screen_coordinate(cell_pos, i_hat, j_hat, cell_dimensions)
    return utils.round_vector_from_coordinates(
        ((cell_pos.x - 1) * i_hat.x * 0.5 * cell_dimensions.x + (cell_pos.y - 1) * j_hat.x * 0.5 * cell_dimensions.x)
        , ((cell_pos.x - 1) * i_hat.y * cell_dimensions.y + (cell_pos.y - 1) * j_hat.y * cell_dimensions.y)
        - (cell_dimensions.z * (cell_pos.z - 1)))
end

local function calculate_grid_data(i_hat, j_hat, grid_dimensions, cell_dimensions)
    local top_left_cell = to_screen_coordinate({ x = 1, y = 1, z = grid_dimensions.z }, i_hat, j_hat,
        cell_dimensions) + utils.round_vector_from_coordinates(cell_dimensions.x / 2, 0)

    local bottom_right_cell = to_screen_coordinate({
            x = grid_dimensions.x,
            y = grid_dimensions.y,
            z = 1
        }, i_hat, j_hat,
        cell_dimensions) + utils.round_vector_from_coordinates(cell_dimensions.x / 2, cell_dimensions.y)

    local bottom_left_cell = to_screen_coordinate({
            x = 1,
            y = grid_dimensions.y,
            z = 1
        }, i_hat, j_hat,
        cell_dimensions) + utils.round_vector_from_coordinates(0, cell_dimensions.y / 2)

    local top_right_cell = to_screen_coordinate({
            x = grid_dimensions.x,
            y = 1,
            z = 1
        }, i_hat, j_hat,
        cell_dimensions) + utils.round_vector_from_coordinates(cell_dimensions.x, cell_dimensions.y / 2)

    local min, max = utils.find_min_max({ top_left_cell, bottom_right_cell, bottom_left_cell, top_right_cell })

    return {
        top_left_cell = top_left_cell,
        bottom_right_cell = bottom_right_cell,
        bottom_left_cell = bottom_left_cell,
        top_right_cell = top_right_cell,
        dimensions = max - min,
        center = -utils.round_vector_from_coordinates((min.x + max.x) / 2, (min.y + max.y) / 2),
    }
end

local function iso_calculator(grid_dimensions, cell_dimensions, screen_dimensions)
    local calculator = {
        i_hat = vector(1, 0.5),
        j_hat = vector(-1, 0.5),
        grid_dimensions = grid_dimensions,
        screen_dimensions = screen_dimensions,
        cell_dimensions = cell_dimensions,
        screen_center = utils.round_vector_from_coordinates(screen_dimensions.width / 2, screen_dimensions.height / 2),
    }

    calculator.grid_data = calculate_grid_data(calculator.i_hat, calculator.j_hat, grid_dimensions,
        cell_dimensions)

    calculator.to_grid_coordinate = function(self, screen_pos)
        local screen_x = screen_pos.x - self.grid_data.center.x - self.screen_center.x
        local screen_y = screen_pos.y - self.grid_data.center.y - self.screen_center.y +
            self.cell_dimensions.z * (screen_pos
                .z - 1)

        local a = self.i_hat.x * 0.5 * self.cell_dimensions.x
        local b = self.j_hat.x * 0.5 * self.cell_dimensions.x
        local c = self.i_hat.y * self.cell_dimensions.y
        local d = self.j_hat.y * self.cell_dimensions.y

        local inv = utils.invert_matrix(a, b, c, d);

        return utils.round_vector_from_coordinates(screen_x * inv.a + screen_y * inv.b,
            (screen_x * inv.c + screen_y * inv.d) + 1)
    end

    calculator.to_screen_coordinate = function(self, cell_pos)
        return to_screen_coordinate(cell_pos, self.i_hat, self.j_hat, self.cell_dimensions) + self.grid_data.center +
            self.screen_center
    end

    return calculator
end

-- Isometric grid module
local grid = {}

grid.NewCell = function(cell_data)
    local new_cell = {
        data = cell_data,
    }

    new_cell.draw_to = function(self, pos, color)
        data.sprite:draw_to(pos, color or data.color)
    end

    return new_cell
end

grid.NewGrid = function()
    local search_box_size = utils.round(data.screen.width / (data.cell.x / 2)) + 4
    local new_grid = {
        calculator = iso_calculator(data.grid, data.cell, data.screen),
        offset = vector(0, 0),
        rounded_offset = vector(0, 0),
        layer_size = vector(data.grid.x, data.grid.y),
        layers = {},
        height_map = {},
        selector_sprites = nil,
        active_layer = 1,
        layer_search_box = vector(search_box_size, search_box_size),
        manhattan_distance = utils.round((data.screen.width / (data.cell.x / 2)) / 2) + 4,
        current_distance = 0,
        selected_cell_pos = vector(0, 0),
        centered_cell_pos = vector(0, 0),
        draw_calls = 0,
    }

    new_grid.init = function(self, tile_data, selector_sprites)
        self.selector_sprites = selector_sprites
        local height_map = {}
        for x = 1, data.grid.x, 1 do
            height_map[x] = {}
            for y = 1, data.grid.y, 1 do
                height_map[x][y] = math.random(0, 5)
            end
        end
        self.height_map = height_map
        for layer_index = 1, data.grid.z, 1 do
            local layer = {
                cells = {},
                sprite_batch = assets.NewSpriteBatch("tile_set",
                    utils.round(((self.layer_search_box.x + 2) * (self.layer_search_box.y + 2)) / 2)),
            }
            for x = 1, data.grid.x, 1 do
                layer.cells[x] = {}
                for y = 1, data.grid.y, 1 do
                    layer.cells[x][y] = tile_data
                end
            end
            self.layers[layer_index] = layer
        end
    end

    new_grid.move_layer_up = function(self)
        if self.active_layer < data.grid.z then
            self.active_layer = self.active_layer + 1
        end
    end

    new_grid.move_layer_down = function(self)
        if self.active_layer > 1 then
            self.active_layer = self.active_layer - 1
        end
    end

    new_grid.scroll = function(self, scroll_direction)
        self.offset = self.offset + scroll_direction
        self.rounded_offset = utils.round_vector(self.offset)
        -- self.offset = utils.limit_point_to_ellipse(self.offset, {
        --     center = vector(0, 0),
        --     dimensions = self.calculator.grid_data.dimensions / 2,
        -- })
        -- self.offset = utils.limit_point_to_rectangle(self.offset, {
        --     a = self.calculator.grid_data.top_left_cell,
        --     b = self.calculator.grid_data.bottom_right_cell,
        --     c = self.calculator.grid_data.bottom_left_cell,
        --     d = self.calculator.grid_data.top_right_cell,
        -- })
    end

    new_grid.update = function(self, dt, mouse_pos)
        self.selected_cell_pos = self.calculator:to_grid_coordinate({
            x = mouse_pos.x + self.offset.x,
            y = mouse_pos.y + self.offset.y,
            z = self.active_layer
        })
        self.centered_cell_pos = self.calculator:to_grid_coordinate({
            x = self.calculator.screen_center.x + self.offset.x,
            y = self.calculator.screen_center.y + self.offset.y,
            z = self.active_layer
        })
        self.current_distance = utils.get_manhattan_distance(self.centered_cell_pos, self.selected_cell_pos)
    end

    -- Find a box within the grid, based on its center and size (in grid coordinates)
    -- if the search box is off the grid, it will be clamped to the grid
    -- if there is no overlap, nill will be returned
    new_grid.find_sorrounding_box = function(self, grid_pos)
        return utils.find_overlap({
            pos = utils.round_vector_from_coordinates(grid_pos.x - self.layer_search_box.x / 2,
                grid_pos.y - self.layer_search_box.y / 2),
            size = self.layer_search_box,
        }, {
            pos = vector(1, 1),
            size = vector(data.grid.x, data.grid.y),
        })
    end

    -- Iterator function that returns nearby cell positions from a given layer
    new_grid.nearby_cell_positions = function(self, layer)
        -- find out the screen-centered cell position on the layer
        local layer_center = self.calculator:to_grid_coordinate({
            x = self.calculator.screen_center.x + self.offset.x,
            y = self.calculator.screen_center.y + self.offset.y,
            z = layer
        })

        -- find the overlapping cells between the layer_search_box and the grid
        local overlap = self:find_sorrounding_box(layer_center)

        -- if there is no overlap, return an empty iterator
        if not overlap then
            return function() return nil end
        end

        -- we start the iterator on the top left corner of the overlap
        local end_of_search = false
        local x = overlap.pos.x
        local y = overlap.pos.y

        return function()
            while not end_of_search do
                local cell_pos = { x = x, y = y, z = layer }

                x = x + 1
                if x == overlap.pos.x + overlap.size.x then
                    x = overlap.pos.x
                    y = y + 1
                end
                if y == overlap.pos.y + overlap.size.y then
                    end_of_search = true
                end

                -- only return cell positions within the manhattan distance,
                -- esentially cutting the rctangle to a diamond shape, and skipping half of the cells
                if utils.within_manhattan_distance(layer_center, cell_pos, self.manhattan_distance) then
                    return cell_pos
                end
            end
        end
    end

    new_grid.draw = function(self)
        self.draw_calls = 0

        -- iterate over layers, starting from the bottom
        for layer = 1, self.active_layer, 1 do
            local draw_color = draw.ColorDarkGray
            if layer == self.active_layer then
                draw_color = draw.ColorWhite
            end
            -- clear the layer sprite batch, and only draw viasbal cells on it
            self.layers[layer].sprite_batch:clear()
            for cell_pos in self:nearby_cell_positions(layer) do
                local cell_screen_pos = self.calculator:to_screen_coordinate({
                        x = cell_pos.x,
                        y = cell_pos.y,
                        z = layer
                    })
                    - vector(0, self.height_map[cell_pos.x][cell_pos.y])
                    - self.rounded_offset

                self.layers[layer].sprite_batch:add(self.layers[layer].cells[cell_pos.x][cell_pos.y].quad_name,
                    cell_screen_pos, vector(1, 1), draw_color)
            end
            -- draw the layer sprite batch
            -- love.graphics.setColor(draw_color)
            self.layers[layer].sprite_batch:draw()
            self.draw_calls = self.draw_calls + 1
        end

        -- draw the selectors
        if utils.is_point_on_rectangle(self.selected_cell_pos, {
                pos = vector(1, 1),
                size = vector(data.grid.x, data.grid.y),
            }) then
            local cell_screen_pos = self.calculator:to_screen_coordinate({
                    x = self.selected_cell_pos.x,
                    y = self.selected_cell_pos.y,
                    z = self.active_layer
                }) - self.rounded_offset -
                vector(0, self.height_map[self.selected_cell_pos.x][self.selected_cell_pos.y])
            self.selector_sprites.green_selector:draw_to(cell_screen_pos)
        end

        if utils.is_point_on_rectangle(self.centered_cell_pos, {
                pos = vector(1, 1),
                size = vector(data.grid.x, data.grid.y),
            }) then
            local cell_screen_pos = self.calculator:to_screen_coordinate({
                    x = self.centered_cell_pos.x,
                    y = self.centered_cell_pos.y,
                    z = self.active_layer
                }) - self.rounded_offset -
                vector(0, self.height_map[self.centered_cell_pos.x][self.centered_cell_pos.y])
            self.selector_sprites.blue_selector:draw_to(cell_screen_pos)
        end
    end

    return new_grid
end

return grid
