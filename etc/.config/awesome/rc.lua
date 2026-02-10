-- awesome_mode: api-level=4:screen=on

---------------------------------------------------------------------------------------------------
--
-- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- Banner generated using `toilet -f pagga AwesomeWM"
--
-- Awesome configuration entry point. This loads all the configs and additional modules
---------------------------------------------------------------------------------------------------

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
require("awful.autofocus")

local origDBUS = dbus
dbus = nil
local naughty = require("naughty")
dbus = origDBUS

-- {{{ Error handling
-- Startup error handling is provided by the fallback config an cannot be overwritten here.
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Error!",
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- ░█▀▄░█▀█░█▀▀░█▀▀
-- ░█▀▄░█▀█░▀▀█░█▀▀
-- ░▀▀░░▀░▀░▀▀▀░▀▀▀

local config = require("config")

-- Theme
require("theme").setup()

-- Setup tagging, tag layouts, bindings and signals
require("tagging").setup()

-- Rules
require("rules").setup()

-- Client bindings and signals
require("client").setup()

-- Global (root) bindings
require("global").setup()

-- Screen setup
require("screen").setup()

-- ░█▄█░█▀█░█▀▄░█░█░█░░░█▀▀░█▀▀
-- ░█░█░█░█░█░█░█░█░█░░░█▀▀░▀▀█
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀

-- Titlebars if required by the client config or a client rule
require("modules.titlebar").setup()

-- Wibar setup
require("modules.wibar").setup()

-- More features:
require("modules.powermenu").setup()
require("modules.behaviors.centerInParent").setup()
require("modules.behaviors.clientOnParentTag").setup()
require("modules.behaviors.AutoBorder").setup()
require("modules.behaviors.AutoOpacity").setup()

-- Qirks - Check regularly if they are still needed?
-- require("modules.quirks.lateRules").setup()
require("modules.quirks.unityRefresh").setup()

-- Notification library - Hack to avoid overriding DBUS notification daemons like dunst
-- package.loaded["naughty.dbus"] = {}
