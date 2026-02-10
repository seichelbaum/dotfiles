---------------------------------------------------------------------------------------------------
--
-- ░█▄█░█▀█░█▀▄░█░█░█░░░█▀▀░░░░░░░▀█▀░▀█▀░▀█▀░█░░░█▀▀░█▀▄░█▀█░█▀▄
-- ░█░█░█░█░█░█░█░█░█░░░█▀▀░░▀░░░░░█░░░█░░░█░░█░░░█▀▀░█▀▄░█▀█░█▀▄
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░░▀░░░░░▀░░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀░░▀░▀░▀░▀
--
---------------------------------------------------------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local config = require("config")
local lib = require("lib")

-- update titlebar visibility
local function updateTitlebarVisibility(c, hideOnly)
    -- Regardless of any setting, if the clients requests to not have a titlebar, hide it.
    if c.requests_no_titlebar then
        awful.titlebar.hide(c)
        return
    end

    -- This user property is true, if titlebars should only be used for floating windows.
    -- NOTE: If the title bar property is true for a client, the bar is shown by default. We only need to handle the floating-case.
    if config.clients.floating.titlebar then
        if c.floating and not c.requests_no_titlebar then
            -- Prevent a recursive request::titlebar call
            if not hideOnly then
                awful.titlebar.show(c)
            end
        else
            awful.titlebar.hide(c)
        end
    end
end

return {
    -- {{{ Setup client titlebars
    setup = function()
        -- Add a titlebar if titlebars_enabled is set to true in the rules.
        client.connect_signal("request::titlebars", function(c)
            -- buttons for the titlebar
            local buttons = gears.table.join(
                awful.button({}, 1, function()
                    c:emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.move(c)
                end),
                awful.button({}, 3, function()
                    c:emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.resize(c)
                end)
            )

            local buttonsTray = wibox.widget({
                {
                    {
                        -- {
                        --     awful.titlebar.widget.stickybutton(c),
                        --     left   = lib.dpi(3),
                        --     top    = lib.dpi(3),
                        --     bottom = lib.dpi(3),
                        --     right  = lib.dpi(3),
                        --     widget = wibox.container.margin,
                        -- },
                        -- {
                        --     awful.titlebar.widget.ontopbutton(c),
                        --     left   = lib.dpi(3),
                        --     top    = lib.dpi(3),
                        --     bottom = lib.dpi(3),
                        --     right  = lib.dpi(3),
                        --     widget = wibox.container.margin,
                        -- },
                        -- {
                        --     awful.titlebar.widget.floatingbutton(c),
                        --     left   = lib.dpi(3),
                        --     top    = lib.dpi(3),
                        --     bottom = lib.dpi(3),
                        --     right  = lib.dpi(3),
                        --     widget = wibox.container.margin,
                        -- },
                        -- {
                        --     awful.titlebar.widget.maximizedbutton(c),
                        --     left   = lib.dpi(3),
                        --     top    = lib.dpi(3),
                        --     bottom = lib.dpi(3),
                        --     right  = lib.dpi(3),
                        --     widget = wibox.container.margin,
                        -- },
                        {
                            awful.titlebar.widget.minimizebutton(c),
                            left = lib.dpi(3),
                            top = lib.dpi(3),
                            bottom = lib.dpi(3),
                            right = lib.dpi(3),
                            widget = wibox.container.margin,
                        },
                        {
                            awful.titlebar.widget.closebutton(c),
                            left = lib.dpi(3),
                            top = lib.dpi(3),
                            bottom = lib.dpi(3),
                            right = lib.dpi(3),
                            widget = wibox.container.margin,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left = lib.dpi(3),
                    top = lib.dpi(0),
                    bottom = lib.dpi(0),
                    right = lib.dpi(3),
                    widget = wibox.container.margin,
                },

                bg = "alpha", --beautiful.palette.bg_lighter3,
                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, lib.dpi(5))
                end,
                shape_clip = true,
                widget = wibox.container.background,
            })

            awful
                .titlebar(c, {
                    size = beautiful.titlebar_height,
                })
                :setup({

                    { -- Left
                        {
                            awful.titlebar.widget.iconwidget(c),
                            buttons = buttons,
                            layout = wibox.layout.fixed.horizontal,
                        },
                        left = lib.dpi(5),
                        top = lib.dpi(5),
                        bottom = lib.dpi(5),
                        right = lib.dpi(5),
                        widget = wibox.container.margin,
                    },
                    { -- Middle
                        { -- Title
                            align = "center",
                            widget = awful.titlebar.widget.titlewidget(c),
                        },
                        buttons = buttons,
                        layout = wibox.layout.flex.horizontal,
                    },
                    { -- Right
                        {
                            buttonsTray,
                            left = lib.dpi(3),
                            top = lib.dpi(3),
                            bottom = lib.dpi(3),
                            right = lib.dpi(3),
                            widget = wibox.container.margin,
                        },

                        layout = wibox.layout.fixed.horizontal(),
                    },

                    layout = wibox.layout.align.horizontal,
                })

            -- Ensure the titlebar visibility is toggled for floats/non-floats
            updateTitlebarVisibility(c, true)
        end)

        -- Setup the floating titlebar
        client.connect_signal("property::floating", function(c)
            updateTitlebarVisibility(c)
        end)
    end,
    -- }}}
}
