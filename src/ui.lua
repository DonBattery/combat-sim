local default_element_properties = {
    name = "default_element_properties",
    prop_priority = 0,
    pos = vector(0, 0),
    size = vector(20, 20),
    color = draw.ColorWhite,
    background_color = draw.ColorLightGray,
    border_color = draw.ColorDarkGray,
    padding = vector(3, 3),
    text = "",
    border_width = 1,
    border_radius = 0,
    text_alignment = "left",
    font = love.graphics.getFont(),
    sprite = nil,
}

local function merge_properties(props)
    table.sort(props, function(prop_a, prop_b)
        return prop_a.prop_priority < prop_b.prop_priority
    end)

    local merged_properties = {}
    for _, properties in ipairs(props) do
        for key, value in pairs(properties) do
            merged_properties[key] = value
        end
    end

    return merged_properties
end

local ui = {}

ui.NewElement = function(element_properties)
    if type(element_properties) ~= "table" then
        element_properties = {
            name = "element_properties",
            prop_priority = 1,
        }
    else
        element_properties.name = element_properties.name or "element_properties"
        element_properties.prop_priority = element_properties.prop_priority or 1
    end

    local element = {
        properties = { default_element_properties, element_properties },
        merged_properties = merge_properties({ default_element_properties, element_properties })
    }

    element.insert_extra_properties = function(self, extra_properties)
        for index, prop in ipairs(self.properties) do
            if prop.name == extra_properties.name then
                table.remove(self.properties, index)
            end
        end
        table.insert(self.properties, extra_properties)
    end

    element.add_extra_properties = function(self, extra_properties, extra_properties_name)
        extra_properties.name = extra_properties_name or "extra_properties"
        extra_properties.prop_priority = extra_properties.prop_priority or 2
        self:insert_extra_properties(extra_properties)
        self.merged_properties = merge_properties(self.properties)
    end

    element.remove_extra_properties = function(self, extra_properties_name)
        extra_properties_name = extra_properties_name or "extra_properties"
        for i, prop in ipairs(self.properties) do
            if prop.name == extra_properties_name then
                table.remove(self.properties, i)
                break
            end
        end
        self.merged_properties = merge_properties(self.properties)
    end

    element.update = function(self, dt, mouse_pos)
    end

    element.draw = function(self)
        draw.rounded_box_with_outline(
            self.merged_properties.pos,
            self.merged_properties.size,
            self.merged_properties.border_width,
            self.merged_properties.border_radius,
            self.merged_properties.background_color,
            self.merged_properties.border_color
        )

        if self.merged_properties.sprite then
            self.merged_properties.sprite:draw_to(self.merged_properties.pos + self.merged_properties.padding,
                self.merged_properties.color)
        end

        if self.merged_properties.text ~= '' then
            love.graphics.setColor(self.merged_properties.color)
            love.graphics.printf(
                self.merged_properties.text,
                self.merged_properties.font,
                self.merged_properties.pos.x + self.merged_properties.padding.x,
                self.merged_properties.pos.y + self.merged_properties.padding.y,
                self.merged_properties.size.x - self.merged_properties.padding.x * 2,
                self.merged_properties.text_alignment
            )
        end
    end

    element.click = function(self, button)
    end

    element.unclick = function(self, button)
    end

    element.hoover = function(self)
    end

    element.unhoover = function(self)
    end

    return element
end

ui.NewBox = function(box_name, box_properties)
    box_properties.box_sprite = assets.factories[box_name](box_properties.size)

    local box = ui.NewElement(box_properties)

    box.draw = function(self)
        self.merged_properties.box_sprite:draw_to(self.merged_properties.pos, self.merged_properties.background_color)

        if self.merged_properties.sprite then
            self.merged_properties.sprite:draw_to(self.merged_properties.pos + self.merged_properties.padding,
                self.merged_properties.color)
        end
    end

    return box
end

ui.static_layout = function(pos, padding, elements)
    local max_width = 0
    local max_height = 0
    for _, element in ipairs(elements) do
        max_width = math.max(max_width, element.merged_properties.pos.x + element.merged_properties.size.x - pos.x)
        max_height = math.max(max_height, element.merged_properties.pos.y + element.merged_properties.size.y - pos.y)
    end
    return vector(max_width, max_height)
end

ui.vertical_layout = function(pos, padding, elements)
    local min_width = data.screen.width
    local max_width = 0
    local min_height = data.screen.height
    local max_height = 0

    for _, element in ipairs(elements) do
        min_width = math.min(min_width, element.merged_properties.size.x)
        max_width = math.max(max_width, element.merged_properties.size.x)
        min_height = math.min(min_height, element.merged_properties.size.y)
        max_height = math.max(max_height, element.merged_properties.size.y)
    end

    local next_y = 0
    for i, element in ipairs(elements) do
        local pos_x = utils.round((max_width - element.merged_properties.size.x) / 2) + pos.x + padding.x
        local pos_y = next_y + pos.y + padding.y * i
        element:add_extra_properties({
            prop_priority = 99,
            pos = vector(pos_x, pos_y),
        }, "layout")
        next_y = next_y + element.merged_properties.size.y
    end

    return vector(max_width + padding.x * 2, max_height * #elements + padding.y * (#elements + 1))
end

ui.horizontal_layout = function(pos, padding, elements)
    local min_width = data.screen.width
    local max_width = 0
    local min_height = data.screen.height
    local max_height = 0

    for _, element in ipairs(elements) do
        min_width = math.min(min_width, element.merged_properties.size.x)
        max_width = math.max(max_width, element.merged_properties.size.x)
        min_height = math.min(min_height, element.merged_properties.size.y)
        max_height = math.max(max_height, element.merged_properties.size.y)
    end

    local next_x = 0
    for i, element in ipairs(elements) do
        local pos_x = next_x + pos.x + padding.x * i
        local pos_y = utils.round((max_height - element.merged_properties.size.y) / 2) + pos.y + padding.y
        element:add_extra_properties({
            prop_priority = 99,
            pos = vector(pos_x, pos_y),
        }, "layout")
        next_x = next_x + element.merged_properties.size.x
    end

    return vector(max_width * #elements + padding.x * (#elements + 1), max_height + padding.y * 2)
end

ui.NewUIFrame = function(pos, padding, layout)
    local next_priority = 0
    local function get_next_priority()
        next_priority = next_priority + 1
        return next_priority
    end

    local new_ui_frame = {
        pos = pos or vector(0, 0),
        padding = padding or vector(0, 0),
        size = vector(0, 0),
        layout = layout or ui.static_layout,
        active = true,
        elements = {},
        mouse_pos = vector(0, 0),
        hoovered_elements = {},
        clicked_elements = {},
    }

    new_ui_frame.activate = function(self)
        self.active = true
    end

    new_ui_frame.deactivate = function(self)
        self.active = false
    end

    new_ui_frame.sort_elements = function(self)
        table.sort(self.elements, function(elem_a, elem_b)
            return elem_a.element_priority < elem_b.element_priority
        end)
    end

    new_ui_frame.do_layout = function(self)
        self.size = self.layout(self.pos, self.padding, self.elements)
    end

    new_ui_frame.set_layout = function(self, layout)
        self.layout = layout or self.layout or ui.static_layout
        self:do_layout()
    end

    new_ui_frame.add_element = function(self, element, priority)
        element.element_priority = priority or get_next_priority()
        element.is_hoovered = false
        table.insert(self.elements, element)
        self:sort_elements()
        self:do_layout()
    end

    new_ui_frame.remove_element = function(self, element)
        for i, elem in ipairs(self.elements) do
            if elem == element then
                table.remove(self.elements, i)
                self:sort_elements()
                self:do_layout()
                break
            end
        end
    end

    new_ui_frame.click = function(self, button)
        self.clicked_elements = {}
        -- Check elements in reverse order so that the elements with the highest priority are checked first
        for i = #self.elements, 1, -1 do
            local element = self.elements[i]
            if utils.is_point_on_rectangle(self.mouse_pos, { pos = element.merged_properties.pos, size = element.merged_properties.size }) then
                table.insert(self.clicked_elements, element)
                element:click(button)
            end
        end
    end

    new_ui_frame.unclick = function(self, button)
        for _, element in ipairs(self.clicked_elements) do
            element:unclick(button)
        end
        self.clicked_elements = {}
    end

    new_ui_frame.update = function(self, dt, mouse_pos)
        self.mouse_pos = mouse_pos

        -- Update elements in reverse order so that the elements with the highest priority are updated first
        for i = #self.elements, 1, -1 do
            local element = self.elements[i]
            if utils.is_point_on_rectangle(mouse_pos, {
                    pos = element.merged_properties.pos,
                    size = element.merged_properties.size
                }) then
                if not element.is_hoovered then
                    element.is_hoovered = true
                    element:hoover()
                end
            elseif element.is_hoovered then
                element.is_hoovered = false
                element:unhoover()
            end
            element:update(dt, mouse_pos)
        end
    end

    new_ui_frame.draw = function(self)
        -- Draw elements in order so that the elements with the lowest priority are drawn first
        for _, element in ipairs(self.elements) do
            element:draw()
        end
        draw.box_outline(self.pos, self.size, draw.ColorWhite)
    end

    return new_ui_frame
end

return ui
