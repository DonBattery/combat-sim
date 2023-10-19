-- These are the four numbers that define the isometric transformation, i hat and j hat
local i_x = 1
local i_y = 0.5
local j_x = -1
local j_y = 0.5

local utils = {}

-- round a number to the nearest integer
utils.round = function(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

utils.NewIsometricCalculator = function(screen_width, screen_height, offset_x, offset_y, tile_width, tile_height,
                                        game_size)
    local calculator = {
        screen_width = screen_width,
        screen_height = screen_height,
        offset_x = offset_x,
        offset_y = offset_y,
        tile_width = tile_width,
        tile_height = tile_height,
        game_size = game_size,
    }

    calculator.invert_matrix = function(self, a, b, c, d)
        -- Determinant of the matrix
        local det = a * d - b * c

        return {
            a = d / det,
            b = -b / det,
            c = -c / det,
            d = a / det,
        }
    end

    calculator.to_grid_coordinate = function(self, screenX, screenY)
        screenX = screenX +
            (self.tile_width / 2) -
            (self.screen_width / 2) -
            self.offset_x

        screenY = screenY -
            (self.screen_height / 2) +
            (self.game_size * self.tile_height / 4) -
            self.offset_y

        local a = i_x * 0.5 * self.tile_width;
        local b = j_x * 0.5 * self.tile_width;
        local c = i_y * 0.5 * self.tile_height;
        local d = j_y * 0.5 * self.tile_height;

        local inv = self:invert_matrix(a, b, c, d);

        return {
            x = utils.round(screenX * inv.a + screenY * inv.b),
            y = utils.round(screenX * inv.c + screenY * inv.d) + 1,
        }
    end

    calculator.to_screen_coordinate = function(self, tileX, tileY)
        -- Accounting for sprite size
        return {
            x = (tileX * i_x * 0.5 * self.tile_width + tileY * j_x * 0.5 * self.tile_width) -
                (self.tile_width / 2) +
                (self.screen_width / 2) +
                self.offset_x,

            y = (tileX * i_y * 0.5 * self.tile_height + tileY * j_y * 0.5 * self.tile_height) +
                (self.screen_height / 2) -
                (self.game_size * self.tile_height / 4) +
                self.offset_y,
        }
    end

    return calculator
end

return utils
