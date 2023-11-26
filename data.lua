return {
    screen = {
        width = 480,
        height = 270,
    },

    grid = {
        x = 10,
        y = 10,
        z = 10,
        max_column_height = 5,
    },

    cell = {
        x = 24,
        y = 12,
        z = 6,
    },

    sprite_sheets = {
        tile_set = "assets/graphics/tile_set.png",
        ui = "assets/graphics/ui.png",
    },

    fonts = {
        default = {
            path = "assets/fonts/at01.ttf",
            size = 16,
        },
    },

    scroll = {
        speed = 200,
    },

    quads = {
        tile = {
            sprite_sheet = "tile_set",
            pos = vector(24, 24),
            size = vector(24, 18),
        },
        green_selector_tile = {
            sprite_sheet = "tile_set",
            pos = vector(0, 24),
            size = vector(24, 13),
        },
        blue_selector_tile = {
            sprite_sheet = "tile_set",
            pos = vector(0, 42),
            size = vector(24, 13),
        },
        yellow_selector_tile = {
            sprite_sheet = "tile_set",
            pos = vector(0, 60),
            size = vector(24, 13),
        },

        -- ui quads
        draw_tool = {
            sprite_sheet = "ui",
            pos = vector(128, 16),
            size = vector(16, 16),
        },
        height_tool = {
            sprite_sheet = "ui",
            pos = vector(144, 16),
            size = vector(16, 16),
        },
        erase_tool = {
            sprite_sheet = "ui",
            pos = vector(160, 16),
            size = vector(16, 16),
        },
        disck_tool = {
            sprite_sheet = "ui",
            pos = vector(176, 16),
            size = vector(16, 16),
        },
        tree_tool = {
            sprite_sheet = "ui",
            pos = vector(192, 16),
            size = vector(16, 16),
        },
    },

    box_factories = {
        grey_box = {
            sprite_sheet = "ui",
            pos = vector(0, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        purple_box = {
            sprite_sheet = "ui",
            pos = vector(16, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        blue_box = {
            sprite_sheet = "ui",
            pos = vector(32, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        green_box = {
            sprite_sheet = "ui",
            pos = vector(48, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        red_box = {
            sprite_sheet = "ui",
            pos = vector(64, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        yellow_box = {
            sprite_sheet = "ui",
            pos = vector(80, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        grey_box_2 = {
            sprite_sheet = "ui",
            pos = vector(96, 0),
            size = vector(16, 16),
            corner_size = vector(4, 4),
        },
        green_box_2 = {
            sprite_sheet = "ui",
            pos = vector(112, 0),
            size = vector(16, 16),
            corner_size = vector(2, 2),
        },
        wooden_box_2 = {
            sprite_sheet = "ui",
            pos = vector(128, 0),
            size = vector(16, 16),
            corner_size = vector(3, 3),
        },
    },

    cursors = {
        default = {
            sprite_sheet = "ui",
            states = {
                top_left = {
                    pos = vector(0, 16),
                    size = vector(16, 16),
                    hot_spot = vector(0, 0),
                },
                top_right = {
                    pos = vector(16, 16),
                    size = vector(16, 16),
                    hot_spot = vector(16, 0),
                },
                bottom_left = {
                    pos = vector(32, 16),
                    size = vector(16, 16),
                    hot_spot = vector(0, 16),
                },
                bottom_right = {
                    pos = vector(48, 16),
                    size = vector(16, 16),
                    hot_spot = vector(16, 16),
                },
                left = {
                    pos = vector(64, 16),
                    size = vector(16, 16),
                    hot_spot = vector(0, 8),
                },
                right = {
                    pos = vector(80, 16),
                    size = vector(16, 16),
                    hot_spot = vector(16, 8),
                },
                bottom = {
                    pos = vector(96, 16),
                    size = vector(16, 16),
                    hot_spot = vector(8, 16),
                },
                top = {
                    pos = vector(112, 16),
                    size = vector(16, 16),
                    hot_spot = vector(8, 0),
                },
            },
        },

        blue = {
            sprite_sheet = "ui",
            states = {
                top_left = {
                    pos = vector(0, 48),
                    size = vector(16, 16),
                    hot_spot = vector(0, 0),
                },
                top_right = {
                    pos = vector(16, 48),
                    size = vector(16, 16),
                    hot_spot = vector(16, 0),
                },
                bottom_left = {
                    pos = vector(32, 48),
                    size = vector(16, 16),
                    hot_spot = vector(0, 16),
                },
                bottom_right = {
                    pos = vector(48, 48),
                    size = vector(16, 16),
                    hot_spot = vector(16, 16),
                },
                left = {
                    pos = vector(64, 48),
                    size = vector(16, 16),
                    hot_spot = vector(0, 8),
                },
                right = {
                    pos = vector(80, 48),
                    size = vector(16, 16),
                    hot_spot = vector(16, 8),
                },
                bottom = {
                    pos = vector(96, 48),
                    size = vector(16, 16),
                    hot_spot = vector(8, 16),
                },
                top = {
                    pos = vector(112, 48),
                    size = vector(16, 16),
                    hot_spot = vector(8, 0),
                },
            },
        },

        green_one = {
            sprite_sheet = "ui",
            states = {
                top_left = {
                    pos = vector(0, 64),
                    size = vector(16, 16),
                    hot_spot = vector(0, 0),
                },
                top_right = {
                    pos = vector(16, 64),
                    size = vector(16, 16),
                    hot_spot = vector(16, 0),
                },
                bottom_left = {
                    pos = vector(32, 64),
                    size = vector(16, 16),
                    hot_spot = vector(0, 16),
                },
                bottom_right = {
                    pos = vector(48, 64),
                    size = vector(16, 16),
                    hot_spot = vector(16, 16),
                },
                left = {
                    pos = vector(64, 64),
                    size = vector(16, 16),
                    hot_spot = vector(0, 8),
                },
                right = {
                    pos = vector(80, 64),
                    size = vector(16, 16),
                    hot_spot = vector(16, 8),
                },
                bottom = {
                    pos = vector(96, 64),
                    size = vector(16, 16),
                    hot_spot = vector(8, 16),
                },
                top = {
                    pos = vector(112, 64),
                    size = vector(16, 16),
                    hot_spot = vector(8, 0),
                },
            },
        },

        green_two = {
            sprite_sheet = "ui",
            states = {
                top_left = {
                    pos = vector(0, 80),
                    size = vector(16, 16),
                    hot_spot = vector(0, 0),
                },
                top_right = {
                    pos = vector(16, 80),
                    size = vector(16, 16),
                    hot_spot = vector(16, 0),
                },
                bottom_left = {
                    pos = vector(32, 80),
                    size = vector(16, 16),
                    hot_spot = vector(0, 16),
                },
                bottom_right = {
                    pos = vector(48, 80),
                    size = vector(16, 16),
                    hot_spot = vector(16, 16),
                },
                left = {
                    pos = vector(64, 80),
                    size = vector(16, 16),
                    hot_spot = vector(0, 8),
                },
                right = {
                    pos = vector(80, 80),
                    size = vector(16, 16),
                    hot_spot = vector(16, 8),
                },
                bottom = {
                    pos = vector(96, 80),
                    size = vector(16, 16),
                    hot_spot = vector(8, 16),
                },
                top = {
                    pos = vector(112, 80),
                    size = vector(16, 16),
                    hot_spot = vector(8, 0),
                },
            },
        },

        grey = {
            sprite_sheet = "ui",
            states = {
                top_left = {
                    pos = vector(0, 96),
                    size = vector(16, 16),
                    hot_spot = vector(0, 0),
                },
                top_right = {
                    pos = vector(16, 96),
                    size = vector(16, 16),
                    hot_spot = vector(16, 0),
                },
                bottom_left = {
                    pos = vector(32, 96),
                    size = vector(16, 16),
                    hot_spot = vector(0, 16),
                },
                bottom_right = {
                    pos = vector(48, 96),
                    size = vector(16, 16),
                    hot_spot = vector(16, 16),
                },
                left = {
                    pos = vector(64, 96),
                    size = vector(16, 16),
                    hot_spot = vector(0, 8),
                },
                right = {
                    pos = vector(80, 96),
                    size = vector(16, 16),
                    hot_spot = vector(16, 8),
                },
                bottom = {
                    pos = vector(96, 96),
                    size = vector(16, 16),
                    hot_spot = vector(8, 16),
                },
                top = {
                    pos = vector(112, 96),
                    size = vector(16, 16),
                    hot_spot = vector(8, 0),
                },
            },
        },

        mini_green = {
            sprite_sheet = "ui",
            states = {
                top_left = {
                    pos = vector(0, 112),
                    size = vector(7, 7),
                    hot_spot = vector(0, 0),
                },
                top_right = {
                    pos = vector(7, 112),
                    size = vector(7, 7),
                    hot_spot = vector(6, 0),
                },
                bottom_left = {
                    pos = vector(14, 112),
                    size = vector(7, 7),
                    hot_spot = vector(0, 6),
                },
                bottom_right = {
                    pos = vector(21, 112),
                    size = vector(7, 7),
                    hot_spot = vector(6, 6),
                },
                left = {
                    pos = vector(28, 112),
                    size = vector(7, 7),
                    hot_spot = vector(0, 3),
                },
                right = {
                    pos = vector(35, 112),
                    size = vector(7, 7),
                    hot_spot = vector(6, 3),
                },
                bottom = {
                    pos = vector(42, 112),
                    size = vector(7, 7),
                    hot_spot = vector(3, 6),
                },
                top = {
                    pos = vector(49, 112),
                    size = vector(7, 7),
                    hot_spot = vector(3, 0),
                },
            },
        },
    }
}
