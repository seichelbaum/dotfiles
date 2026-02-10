---------------------------------------------------------------------------------------------------
--
-- ░█▀▄░█░█░█░░░█▀▀░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀▄░█░█░█░░░█▀▀░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀▀▀░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- Awesome rule configuration.
---------------------------------------------------------------------------------------------------

-- local ruled = require("ruled")
local awful = require("awful")
local gears = require("gears")

local lib = require("lib")
local config = require("config")

-- {{{ Library: Prepare and format rules

-- Unroll the by-tag rule set into a flat set of rules. This evaluates the tagId and tries to find the right tag.
local function flatten(rulesByTag)
    local flatRules = {}
    for i = 1, #rulesByTag do
        local rules = rulesByTag[i].rules
        local tag = lib.tags.getTagByID(rulesByTag[i].tagId)

        for ruleI = 1, #rules do
            local rule = rules[ruleI]
            rule.properties.tag = tag
            flatRules[#flatRules + 1] = rule
        end
    end
    return flatRules
end
-- }}}

return {
    setup = function()
        -- All clients will match this rule.
        awful.rules.rules = gears.table.join(awful.rules.rules, {
            { id = "global", rule = {}, properties = config.clients.properties },
        })

        -- Add the custom rules
        awful.rules.rules = gears.table.join(awful.rules.rules, flatten(config.rules))
    end,
}
