local editor_ui = {}

local function NewToolButton(tool_name, box_name, pos, on_click_fn)
    local tool_button       = ui.NewBox(box_name, {
        pos = pos,
        size = vector(22, 22),
        padding = vector(3, 3),
        background_color = draw.ColorLightGray,
        color = draw.ColorLightGray,
        sprite = assets.NewSprite("ui", tool_name, draw.ColorWhite),
    })
    tool_button.on_click_fn = on_click_fn

    tool_button.hoover      = function(self)
        print(tool_name .. " button hoovered")
        self:add_extra_properties({
            color = draw.ColorWhite,
            background_color = draw.ColorWhite,
        }, "hoover")
    end

    tool_button.unhoover    = function(self)
        print(tool_name .. " button unhoovered")
        self:remove_extra_properties("hoover")
    end

    tool_button.click       = function(self, button)
        print(tool_name .. " button clicked with mouse button: " .. button)
        self:add_extra_properties({
            prop_priority = 999,
            pos = self.merged_properties.pos + vector(1, 2),
            background_color = draw.ColorWhite,
        })
        self.on_click_fn()
    end

    tool_button.unclick     = function(self, button)
        print(tool_name .. " button unclicked with mouse button: " .. button)
        self:remove_extra_properties()
    end

    return tool_button
end

editor_ui.NewEditorUI = function()
    local layout             = "vertical_layout"

    local frame              = ui.NewUIFrame(vector(0, 0), vector(3, 3), ui.vertical_layout)

    local disck_tool_button  = NewToolButton("disck_tool", "blue_box", vector(10, 10), function()
        print("Disck tool clicked")
        if layout == "vertical_layout" then
            frame:set_layout(ui.horizontal_layout)
            layout = "horizontal_layout"
        else
            frame:set_layout(ui.vertical_layout)
            layout = "vertical_layout"
        end
    end)

    local draw_tool_button   = NewToolButton("draw_tool", "blue_box", vector(10, 40), function() end)
    local erase_tool_button  = NewToolButton("erase_tool", "blue_box", vector(10, 70), function() end)
    local height_tool_button = NewToolButton("height_tool", "blue_box", vector(10, 100), function() end)
    local tree_tool_button   = NewToolButton("tree_tool", "blue_box", vector(10, 130), function() end)


    local tools_tab    = ui.NewBox("grey_box", {
        pos = vector(2, 2),
        size = vector(40, 158),
        background_color = draw.ColorSemiTransparentWhite,
        auto_layout = false,
    })

    tools_tab.hoover   = function(self)
        print("Tools tab hoovered")
        self:add_extra_properties({
        }, "hoover")
    end

    tools_tab.unhoover = function(self)
        print("Tools tab unhoovered")
        self:remove_extra_properties("hoover")
    end

    -- frame:add_element(tools_tab)
    frame:add_element(disck_tool_button)
    frame:add_element(draw_tool_button)
    frame:add_element(erase_tool_button)
    frame:add_element(height_tool_button)
    frame:add_element(tree_tool_button)
    -- for _, value in ipairs(frame.elements) do
    --     print("Element priority", value.element_priority)
    -- end


    local new_editor_ui = {
        frame_1 = frame,
    }

    new_editor_ui.update = function(self, dt, mouse_pos)
        self.frame_1:update(dt, mouse_pos)
    end

    new_editor_ui.mousepressed = function(self, button)
        self.frame_1:click(button)
    end

    new_editor_ui.mousereleased = function(self, button)
        self.frame_1:unclick(button)
    end

    new_editor_ui.draw = function(self)
        self.frame_1:draw()
    end

    return new_editor_ui
end

return editor_ui
