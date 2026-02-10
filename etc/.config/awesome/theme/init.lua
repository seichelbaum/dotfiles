---------------------------------------------------------------------------------------------------
--
-- ░▀█▀░█░█░█▀▀░█▄█░█▀▀░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░░█░░█▀█░█▀▀░█░█░█▀▀░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
---------------------------------------------------------------------------------------------------

local gears = require("gears")
local beautiful = require("beautiful")

local style = require("config").style
local lib = require("lib")

return {
    setup = function()
        -- Themes define colours, icons, font and wallpapers. Use the system default as baseline
        local theme = dofile(gears.filesystem.get_themes_dir() .. "default/theme.lua")

        -- The theme module base path
        local path = gears.filesystem.get_configuration_dir() .. "/theme/"
        local iconPath = path .. "icons/"
        theme.iconPath = iconPath

        -- {{{ Fonts

        -- Some fonts provide their own bold version. If the user specifies a bold version, use it. If not, use the boldified version of the regular font.
        local boldFont =
            lib.ternary(style.fontBold == nil or style.fontBold == "", style.font .. " bold", style.fontBold)

        theme.font = style.font
        theme.tasklist_font = boldFont
        theme.taglist_font = style.tagFont
        theme.titlebar_font = boldFont

        -- }}}

        -- {{{ Sizes and Gaps

        theme.useless_gap = lib.dpi(style.gap)
        theme.border_width = lib.dpi(style.borderWidth)
        theme.wibar_height = lib.dpi(32)
        theme.titlebar_height = lib.dpi(32)
        theme.menu_height = lib.dpi(32)
        theme.menu_width = lib.dpi(200)
        theme.menu_border_width = lib.dpi(0)

        -- }}}

        -- The icon theme name. It has to be a directory in /usr/share/icons or an XDG icon folder.
        -- NOTE: does not work?!
        theme.icon_theme = nil -- "Papirus"

        -- Wallpaper
        if type(style.wallpaper) == "function" then
            style.wallpaper()
        else
            theme.wallpaper = style.wallpaper
        end

        -- {{{ Palette
        theme.palette = {
            -- Use to highlight field with unknown purpose
            unknown = "#ff00f0",

            -- Default BG and its shades
            bg = "#141415",
            bg_lighter1 = "#19191a",
            bg_lighter2 = "#202021",
            bg_lighter3 = "#272728",
            bg_lighter4 = "#333335",
            bg_lighter5 = "#44464a",

            -- Default FG and its shades
            fg_lighter1 = "#ffffff",
            fg = "#eeeeee",
            fg_darker1 = "#dddddd",
            fg_darker2 = "#cccccc",
            fg_darker3 = "#aaaaaa",

            -- Primary color. Usually used to stear users focus towards something.
            primary = "#31648d",
            -- A bit brighter variant, use this for high contrast parts where the darker primary color would be hard to see
            primary_variant = "#4a88cc",
            primary_darker1 = "#21547d",

            -- Secondary color. Used for secondary highlights
            secondary = "#febc2e",

            -- Color to highlight urgend things that require attention.
            attention_darker1 = "#ca383a",
            attention = "#fd5f57",
        }

        -- }}}

        -- {{{ Colors

        -- Base colors. If no other colors are defined, Awesome derives everything from these.
        theme.bg_normal = theme.palette.bg
        theme.bg_focus = theme.palette.primary
        theme.bg_urgent = theme.palette.attention
        theme.bg_minimize = theme.palette.bg_lighter5

        theme.fg_normal = theme.palette.fg
        theme.fg_focus = theme.palette.fg_darker1
        theme.fg_urgent = theme.palette.fg
        theme.fg_minimize = theme.palette.fg

        -- Border style

        theme.border_normal = theme.palette.bg_lighter3
        theme.border_focus = theme.palette.primary
        theme.border_urgent = theme.palette.attention
        theme.border_marked = theme.palette.unknown

        -- Taglist

        -- This matches the generated defaults:
        theme.taglist_bg_focus = theme.palette.primary_variant
        -- theme.taglist_bg_occupied    = theme.palette.bg_lighter5
        -- theme.taglist_bg_urgent   = theme.palette.attention

        -- theme.taglist_fg_occupied = theme.palette.fg
        -- theme.taglist_fg_focus    = theme.palette.fg
        -- theme.taglist_fg_urgent   = theme.palette.fg

        -- Tasklist

        --theme.tasklist_bg_focus     = "alpha"
        --theme.tasklist_bg_urgent    = theme.palette.attention
        --theme.tasklist_fg_focus     = "#cccccc"
        --theme.tasklist_fg_urgent    = "#ffffff"

        -- Titlebars

        -- They deviate quite a bit from the default:
        theme.titlebar_bg_normal = theme.palette.bg_lighter2
        theme.titlebar_bg_focus = theme.palette.bg_lighter5
        theme.titlebar_fg_normal = theme.palette.fg_darker3
        theme.titlebar_fg_focus = theme.palette.fg

        -- Colors used by the widgets.

        theme.widgets = {
            bg = {
                common = theme.palette.bg_lighter4,
                clock = theme.palette.primary,

                -- The color used for the actual systray icon backgrounds. Alpha is not supported so an explicit color must be set.
                systrayBuiltin = theme.palette.bg,
                systray = "#5392a7", --theme.palette.bg_lighter3,

                battery = "#93a753", -- theme.palette.bg_lighter2,
                volume = "#bc8b3b", --theme.palette.bg_lighter1,
                brightness = "#bc6d3b", --theme.palette.bg_lighter1,

                monitors = "#a75353", --theme.palette.bg,
            },

            fg = {
                markupMain = theme.palette.fg_lighter1,
                markupSide = theme.palette.fg_darker3,
            },
        }
        -- }}}

        -- {{{ Icons - Load and map to the correct path

        -- {{{ Layout icons
        theme.layout_tile = iconPath .. "layouts/tile.png"
        theme.layout_tileleft = iconPath .. "layouts/tileleft.png"
        theme.layout_tilebottom = iconPath .. "layouts/tilebottom.png"
        theme.layout_tiletop = iconPath .. "layouts/tiletop.png"
        theme.layout_fairv = iconPath .. "layouts/fairv.png"
        theme.layout_fairh = iconPath .. "layouts/fairh.png"
        theme.layout_spiral = iconPath .. "layouts/spiral.png"
        theme.layout_dwindle = iconPath .. "layouts/dwindle.png"
        theme.layout_max = iconPath .. "layouts/max.png"
        theme.layout_fullscreen = iconPath .. "layouts/fullscreen.png"
        theme.layout_magnifier = iconPath .. "layouts/magnifier.png"
        theme.layout_floating = iconPath .. "layouts/floating.png"
        theme.layout_cascadetile = iconPath .. "layouts/cascadetile.png"
        -- }}}

        -- {{{ Taglist icons
        --theme.taglist_squares_sel   = iconPath .. "taglist/none.png"
        --theme.taglist_squares_unsel = iconPath .. "taglist/none.png"
        -- }}}

        -- {{{ Tasklist icons/styles
        theme.tasklist_floating = "<b>F </b>"
        theme.tasklist_maximized = "<b>+ </b>"
        theme.tasklist_minimized = "<b>_ </b>"
        -- }}}

        -- {{{ Titlebar icons/styles
        theme.titlebar_close_button_focus =
            gears.color.recolor_image(iconPath .. "titlebar/button.svg", theme.palette.attention)
        theme.titlebar_close_button_normal =
            gears.color.recolor_image(iconPath .. "titlebar/button.svg", theme.palette.bg_lighter3)
        theme.titlebar_minimize_button_focus =
            gears.color.recolor_image(iconPath .. "titlebar/ring.svg", theme.palette.secondary)
        theme.titlebar_minimize_button_normal =
            gears.color.recolor_image(iconPath .. "titlebar/ring.svg", theme.palette.bg_lighter3)
        beautiful.theme_assets.recolor_titlebar(theme, theme.palette.fg_darker3, "focus")
        beautiful.theme_assets.recolor_titlebar(theme, theme.palette.bg_lighter4, "normal")
        -- }}}

        -- }}}

        beautiful.init(theme)
    end,
}
