local black_and_white_shader_code_1 = [[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 c = Texel(texture, texture_coords); // This reads a color from our texture at the coordinates LOVE gave us (0-1, 0-1)
        vec3 lumCoeff = vec3(0.3, 0.59, 0.11);  // These are the values used to calculate the luminance of a pixel, which is the grayscale value of a pixel. The human eye is more sensitive to green than other colors, so we weight it more heavily.
        float weighted_avarage = dot(color.rgb, lumCoeff) / 3; // This calculates the weighted avarage of the color channels, which is the grayscale value of the pixel.
        // float weighted_avarage = (c.r + c.g + c.b) / 3;
        return vec4(weighted_avarage, weighted_avarage, weighted_avarage, c.a); // We return a new color with the grayscale value as the RGB channels, and the alpha channel unchanged.
    }
]]

local black_and_white_shader_code_2 = [[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 c = Texel(texture, texture_coords);
        float weighted_avarage = (color.r * 0.3 + c.r * 0.3 + color.g * 0.59 + c.g * 0.59 + color.b * 0.11 + c.b * 0.11) / 2.5;
        return vec4(weighted_avarage, weighted_avarage, weighted_avarage, c.a);
    }
]]

local wave_effect_shader_code = [[
    uniform float time;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec2 offset = vec2(0.0, sin(time + screen_coords.x * 0.1) * 10.0); // Adjust the values to control the wave effect
        vec4 tex_color = Texel(texture, texture_coords + offset);
        return color * tex_color;
    }
]]

local shader = {
    black_and_white_1 = love.graphics.newShader(black_and_white_shader_code_1),
    black_and_white_2 = love.graphics.newShader(black_and_white_shader_code_2),
    wave_effect = love.graphics.newShader(wave_effect_shader_code),
}

return shader
