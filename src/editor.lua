local editor = {}

local function NewMouse(cursor, color)
    local mouse = {
        cursor = cursor or "default",
        color = color,
        cursor_state = "top_left",
        position = vector(0, 0),
        scroll_direction = vector(0, 0),
    }

    mouse.update = function(self, dt, mouse_pos)
        self.cursor_state = "top_left"
        self.scroll_direction = vector(0, 0)
        if mouse_pos.x == 0 and mouse_pos.y == 0 then
            self.scroll_direction = vector(-1, -1)
        elseif mouse_pos.y == 0 and mouse_pos.x > 0 and mouse_pos.x < data.screen.width then
            self.cursor_state = "top"
            self.scroll_direction = vector(0, -1)
        elseif mouse_pos.y == 0 and mouse_pos.x == data.screen.width then
            self.cursor_state = "top_right"
            self.scroll_direction = vector(1, -1)
        elseif mouse_pos.x == data.screen.width and mouse_pos.y > 0 and mouse_pos.y < data.screen.height then
            self.cursor_state = "right"
            self.scroll_direction = vector(1, 0)
        elseif mouse_pos.x == data.screen.width and mouse_pos.y == data.screen.height then
            self.cursor_state = "bottom_right"
            self.scroll_direction = vector(1, 1)
        elseif mouse_pos.y == data.screen.height and mouse_pos.x > 0 and mouse_pos.x < data.screen.width then
            self.cursor_state = "bottom"
            self.scroll_direction = vector(0, 1)
        elseif mouse_pos.y == data.screen.height and mouse_pos.x == 0 then
            self.cursor_state = "bottom_left"
            self.scroll_direction = vector(-1, 1)
        elseif mouse_pos.x == 0 and mouse_pos.y > 0 and mouse_pos.y < data.screen.height then
            self.cursor_state = "left"
            self.scroll_direction = vector(-1, 0)
        end
        self.position = mouse_pos
    end

    mouse.draw = function(self)
        assets.cursors[self.cursor].states[self.cursor_state]:draw_to(self.position, self.color)
    end

    return mouse
end

editor.NewEditor = function()
    local new_editor = {
        debug = false,
        editor_ui = editor_ui.NewEditorUI(),
        grid = grid.NewGrid(),
        active_layer = 1,
        mouse = NewMouse("green_one", draw.ColorWhite),
    }


    new_editor.toggle_debug = function(self)
        self.debug = not self.debug
    end

    new_editor.keypressed = function(self, key)
        if key == "escape" then
            love.event.quit()
        elseif key == "f1" then
            push:switchFullscreen()
        elseif key == "d" then
            self:toggle_debug()
        end
    end

    new_editor.keyreleased = function(self, key)

    end

    new_editor.mousepressed = function(self, button)
        self.editor_ui:mousepressed(button)
    end

    new_editor.mousereleased = function(self, button)
        self.editor_ui:mousereleased(button)
    end

    new_editor.wheelmoved = function(self, x, y)
        if y > 0 then
            self.grid:move_layer_up()
        elseif y < 0 then
            self.grid:move_layer_down()
        end
    end

    new_editor.update = function(self, dt, mouse_pos)
        self.mouse:update(dt, mouse_pos)
        self.editor_ui:update(dt, mouse_pos)
        self.grid:update(dt, mouse_pos)

        if self.mouse.scroll_direction.x ~= 0 or self.mouse.scroll_direction.y ~= 0 then
            self.grid:scroll(self.mouse.scroll_direction * dt * data.scroll.speed)
        end
    end

    new_editor.debug_lines = function(self)
        draw.line(utils.round_vector_from_coordinates(data.screen.width / 2, 0),
            utils.round_vector_from_coordinates(data.screen.width / 2,
                data.screen.height), 1, draw.ColorWhite)
        draw.line(utils.round_vector_from_coordinates(0, data.screen.height / 2),
            utils.round_vector_from_coordinates(data.screen.width,
                data.screen.height / 2), 1, draw.ColorWhite)
    end

    new_editor.draw = function(self)
        self.grid:draw()
        self.editor_ui:draw()
        if self.debug then
            self:debug_lines()
        end
        self.mouse:draw()
    end

    return new_editor
end

return editor
