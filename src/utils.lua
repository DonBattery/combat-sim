local utils = {}

-- round a number to the nearest integer
utils.round = function(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

utils.round_vector_from_coordinates = function(x, y)
    return vector(utils.round(x), utils.round(y))
end

utils.round_vector = function(v)
    return vector(utils.round(v.x), utils.round(v.y))
end

utils.limit_digits = function(number, digits)
    local factor = 10 ^ digits
    return utils.round(number * factor) / factor
end

utils.contains = function(list, value)
    for _, v in ipairs(list) do
        if v == value then
            return true
        end
    end

    return false
end

utils.find_min_max = function(vectors)
    local min = vector(math.huge, math.huge)
    local max = vector(-math.huge, -math.huge)

    for _, v in pairs(vectors) do
        if v.x < min.x then
            min.x = v.x
        end
        if v.y < min.y then
            min.y = v.y
        end
        if v.x > max.x then
            max.x = v.x
        end
        if v.y > max.y then
            max.y = v.y
        end
    end

    return min, max
end

utils.time_from_milliseconds = function(milliseconds)
    local hours = math.floor(milliseconds / 3600000)
    local minutes = math.floor((milliseconds - hours * 3600000) / 60000)
    local seconds = math.floor((milliseconds - hours * 3600000 - minutes * 60000) / 1000)
    local milliseconds = milliseconds - hours * 3600000 - minutes * 60000 - seconds * 1000
    return hours, minutes, seconds, milliseconds
end

utils.time_string_from_milliseconds = function(milliseconds)
    local hours, minutes, seconds, milliseconds = utils.time_from_milliseconds(milliseconds)
    return hours .. ":" .. minutes .. ":" .. seconds .. ":" .. utils.limit_digits(milliseconds, 4)
end

utils.invert_matrix = function(a, b, c, d)
    -- Determinant of the matrix
    local det = a * d - b * c
    return {
        a = d / det,
        b = -b / det,
        c = -c / det,
        d = a / det,
    }
end

utils.get_manhattan_distance = function(pos1, pos2)
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

utils.within_manhattan_distance = function(pos1, pos2, distance)
    return utils.get_manhattan_distance(pos1, pos2) <= distance
end

utils.is_point_on_rectangle = function(point, rectangle)
    return point.x >= rectangle.pos.x and point.x < rectangle.pos.x + rectangle.size.x and
        point.y >= rectangle.pos.y and point.y < rectangle.pos.y + rectangle.size.y
end

utils.is_rectangle_overlap = function(rect1, rect2)
    return rect1.pos.x < rect2.pos.x + rect2.size.x and
        rect1.pos.x + rect1.size.x > rect2.pos.x and
        rect1.pos.y < rect2.pos.y + rect2.size.y and
        rect1.pos.y + rect1.size.y > rect2.pos.y
end

utils.find_overlap = function(rect1, rect2)
    local overlap_x = math.max(0,
        math.min(rect1.pos.x + rect1.size.x, rect2.pos.x + rect2.size.x) - math.max(rect1.pos.x, rect2.pos.x))
    local overlap_y = math.max(0,
        math.min(rect1.pos.y + rect1.size.y, rect2.pos.y + rect2.size.y) - math.max(rect1.pos.y, rect2.pos.y))

    if overlap_x > 0 and overlap_y > 0 then
        local overlap_area = {
            pos = {
                x = math.max(rect1.pos.x, rect2.pos.x),
                y = math.max(rect1.pos.y, rect2.pos.y),
            },
            size = {

                x = overlap_x,
                y = overlap_y,
            }
        }
        return overlap_area
    else
        -- No overlap
        return nil
    end
end

-- Function to limit a point's position to be within a circle
utils.limit_point_to_circle = function(point, circle_center, circle_radius)
    -- Calculate the distance from the center of the circle
    local distance = math.sqrt((point.x - circle_center.x) ^ 2 + (point.y - circle_center.y) ^ 2)

    -- Set the new point to the current point
    local new_point = vector(point.x, point.y)

    -- If the distance is greater than the radius, adjust the new point position
    if distance > circle_radius then
        -- Calculate the angle between the center and the new point
        local angle = math.atan2(point.y - circle_center.y, point.x - circle_center.x)

        -- Set the new point to the edge of the circle
        new_point.x = circle_center.x + circle_radius * math.cos(angle)
        new_point.y = circle_center.y + circle_radius * math.sin(angle)
    end

    return new_point
end

-- utils.limit_point_to_ellipse = function(point, ellipse_center, ellipse_dimensions)
--     -- Calculate the distance from the center of the ellipse
--     local distance = math.sqrt((point.x - ellipse_center.x) ^ 2 / ellipse_dimensions.x ^ 2 +
--         (point.y - ellipse_center.y) ^ 2 / ellipse_dimensions.y ^ 2)

--     -- Set the new point to the current point
--     local new_point = vector(point.x, point.y)

--     -- If the distance is greater than the radius, adjust the new point position
--     if distance > 1 then
--         -- Calculate the angle between the center and the new point
--         local angle = math.atan2(point.y - ellipse_center.y, point.x - ellipse_center.x)

--         -- Set the new point to the edge of the ellipse
--         new_point.x = ellipse_center.x + ellipse_dimensions.x * math.cos(angle)
--         new_point.y = ellipse_center.y + ellipse_dimensions.y * math.sin(angle)
--     end

--     return new_point
-- end

utils.limit_point_to_ellipse = function(point, ellipse)
    -- Calculate the distance from the center of the ellipse
    local distance = math.sqrt(((point.x - ellipse.center.x) / ellipse.dimensions.x) ^ 2 +
        ((point.y - ellipse.center.y) / ellipse.dimensions.y) ^ 2)

    local new_point = vector(point.x, point.y)

    -- If the distance is greater than 1, adjust the point position
    if distance > 1 then
        -- Calculate the angle between the center and the point
        local angle = math.atan2((point.y - ellipse.center.y) / ellipse.dimensions.y,
            (point.x - ellipse.center.x) / ellipse.dimensions.x)

        -- Set the point to the edge of the ellipse
        new_point.x = ellipse.center.x + ellipse.dimensions.x * math.cos(angle)
        new_point.y = ellipse.center.y + ellipse.dimensions.y * math.sin(angle)
    end

    return new_point
end

-- Function to determine if a point is inside a rectangle
local function isPointInsideRectangle(x, y, A, B, C, D)
    -- Check if the point is inside the rectangle using the convex hull method
    local function isInsideTriangle(x, y, x1, y1, x2, y2, x3, y3)
        local function sign(px, py, qx, qy, rx, ry)
            return (px - rx) * (qy - ry) - (qx - rx) * (py - ry)
        end

        local d1 = sign(x, y, x1, y1, x2, y2)
        local d2 = sign(x, y, x2, y2, x3, y3)
        local d3 = sign(x, y, x3, y3, x1, y1)

        local hasNeg = (d1 < 0) or (d2 < 0) or (d3 < 0)
        local hasPos = (d1 > 0) or (d2 > 0) or (d3 > 0)

        return not (hasNeg and hasPos)
    end

    return isInsideTriangle(x, y, A.x, A.y, B.x, B.y, C.x, C.y) or
        isInsideTriangle(x, y, A.x, A.y, C.x, C.y, D.x, D.y)
end

-- Function to find the nearest point on the rectangle's edge
local function nearestPointOnRectangleEdge(x, y, A, B, C, D)
    local function distanceSquared(px, py, qx, qy)
        local dx = qx - px
        local dy = qy - py
        return dx * dx + dy * dy
    end

    local function closestPointOnSegment(px, py, x1, y1, x2, y2)
        local dx = x2 - x1
        local dy = y2 - y1
        local t = ((px - x1) * dx + (py - y1) * dy) / (dx * dx + dy * dy)

        if t < 0 then
            t = 0
        elseif t > 1 then
            t = 1
        end

        local closestX = x1 + t * dx
        local closestY = y1 + t * dy

        return closestX, closestY
    end

    local nearestPoint = { x = A.x, y = A.y }
    local minDistance = distanceSquared(x, y, A.x, A.y)

    local edges = {
        { A.x, A.y, B.x, B.y },
        { B.x, B.y, C.x, C.y },
        { C.x, C.y, D.x, D.y },
        { D.x, D.y, A.x, A.y }
    }

    for _, edge in ipairs(edges) do
        local closestX, closestY = closestPointOnSegment(x, y, edge[1], edge[2], edge[3], edge[4])
        local dist = distanceSquared(x, y, closestX, closestY)

        if dist < minDistance then
            minDistance = dist
            nearestPoint = { x = closestX, y = closestY }
        end
    end

    return utils.round_vector_from_coordinates(nearestPoint.x, nearestPoint.y)
end

utils.limit_point_to_rectangle = function(point, rectangle)
    if isPointInsideRectangle(point.x, point.y, rectangle.a, rectangle.b, rectangle.c, rectangle.d) then
        return point
    end
    return nearestPointOnRectangleEdge(point.x, point.y, rectangle.a, rectangle.b, rectangle.c, rectangle.d)
end

utils.list_difference = function(list1, list2)
    local difference = {}

    for _, v in ipairs(list1) do
        if not utils.contains(list2, v) then
            table.insert(difference, v)
        end
    end

    return difference
end

-- checks if a point is inside a polygon
utils.is_point_in_polygon = function(point, polygon)
    local x, y = point[1], point[2]
    local is_inside = false
    local n = #polygon

    for i = 1, n do
        local x1, y1 = polygon[i][1], polygon[i][2]
        local x2, y2 = polygon[(i % n) + 1][1], polygon[(i % n) + 1][2]

        if (y1 > y) ~= (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1 then
            is_inside = not is_inside
        end
    end

    return is_inside
end

function utils.NewTileSelector(max_size)
    local tile_selector = {
        max_size = max_size or 1,
        pos = vector(0, 0),
        size = 1,
        previous_pos = vector(0, 0),
        previous_size = 1,
    }

    tile_selector.info = function(self)
        return "Tile selector: pos " .. self.pos.x .. ", " .. self.pos.y .. " size " .. self.size
    end

    tile_selector.set_position = function(self, x, y)
        self.pos.x = x
        self.pos.y = y
    end

    tile_selector.increase_size = function(self)
        if self.size < self.max_size then
            self.size = self.size + 1
        end
    end

    tile_selector.decrase_size = function(self)
        if self.size > 1 then
            self.size = self.size - 1
        end
    end

    tile_selector.get_tile_positions = function(self, pos, size)
        local positions = {}
        for row = 1, size, 1 do
            for col = 1, size, 1 do
                local tile_pos = vector(pos.x + col - 1, pos.y + row - 1)
                if tile_pos.x > 0 and tile_pos.x <= self.max_size and tile_pos.y > 0 and tile_pos.y <= self.max_size then
                    table.insert(positions, tile_pos)
                end
            end
        end
        return positions
    end

    tile_selector.get_selected_tile_positions = function(self)
        return self:get_tile_positions(self.pos, self.size)
    end

    tile_selector.get_previous_selected_tile_positions = function(self)
        return self:get_tile_positions(self.previous_pos, self.previous_size)
    end

    tile_selector.update = function(self)
        local output = {
            add_selection = {},
            remove_selection = {},
        }

        if self.pos.x ~= self.previous_pos.x or
            self.pos.y ~= self.previous_pos.y or
            self.size ~= self.previous_size then
            local previous_positions = self:get_previous_selected_tile_positions()
            local current_positions = self:get_selected_tile_positions()
            output.add_selection = utils.list_difference(current_positions, previous_positions)
            output.remove_selection = utils.list_difference(previous_positions, current_positions)
            self.previous_pos.x = self.pos.x
            self.previous_pos.y = self.pos.y
            self.previous_size = self.size
        end

        return output
    end

    return tile_selector
end

return utils
