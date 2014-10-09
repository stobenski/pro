--- Cycle through recently focused clients (Alt-Tab and more).
--
-- Author: http://daniel.hahler.de
-- Github: https://github.com/blueyed/awesome-cyclefocus

local awful        = require('awful')
-- local setmetatable = setmetatable
local naughty      = require("naughty")
local table        = table
local tostring     = tostring
local gears        = require('gears')
local capi         = {
--     tag            = tag,
    client         = client,
    keygrabber     = keygrabber,
--     mousegrabber   = mousegrabber,
    mouse          = mouse,
    screen         = screen
}


-- Configuration. This can be overridden: global or via args to cyclefocus.cycle.
local cyclefocus
cyclefocus = {
    -- Should clients be raised during cycling?
    raise_clients = false,
    -- Should clients be focused during cycling?
    focus_clients = true,

    -- How many entries should get displayed before and after the current one?
    display_next_count = 8,
    display_prev_count = 0,  -- only 0 for prev, works better with naughty notifications.

    -- Preset to be used for the notification.
    naughty_preset = {
        position = 'top_right',
        timeout = 0,
        border_width = 0,
        fg = "#FFFFFF88",
        bg = "#22222255",
    },

    naughty_preset_for_offset = {
        -- Default callback, which will be applied for all offsets (first).
        default = function (preset, args)
            -- Default font and icon size (gets overwritten for current/0 index).
            preset.font = 'Open Sans 8'
            preset.icon_size = 16
            preset.text = preset.text or cyclefocus.get_object_name(args.client)

            -- Display the notification on the current screen (mouse).
            preset.screen = capi.mouse.screen

            -- Set notification width, based on screen/workarea width.
            local s = preset.screen
            local wa = capi.screen[s].workarea
            -- preset.width = wa.width * 0.618
            preset.width = 400

            preset.icon = gears.surface.load(args.client.icon) -- using gears prevents memory leaking
        end,

        -- Preset for current entry.
        ["0"] = function (preset, args)
            preset.fg = "#DDDDDD"
            preset.bg = "#1F1F1F"
            preset.font = 'Open Sans 8'
            preset.icon_size = 16
            -- Use get_object_name to handle .name=nil.
            preset.text = cyclefocus.get_object_name(args.client)
                    .. " [screen " .. args.client.screen .. "]"
                    .. " [" .. args.idx .. "/" .. args.total .. "] "
            -- XXX: Makes awesome crash:
            -- preset.text = '<span gravity="auto">' .. preset.text .. '</span>'
            -- preset.text = '<b>' .. preset.text .. '</b>'
            preset.text = preset.text 
        end,

        -- You can refer to entries by their offset.
        ["-1"] = function (preset, args)
            -- preset.icon_size = 24
        end,
        ["1"] = function (preset, args)
            -- preset.icon_size = 44
        end
    },

    -- Default filters: return false to ignore/hide a client.
    cycle_filters = {
        function(c, source_c) return not c.minimized end,
    },

    -- The filter to ignore clients altogether (get not added to the history stack).
    -- This is different from the cycle_filters.
    filter_focus_history = awful.client.focus.filter,

    -- Display notifications while cycling?
    -- WARNING: without raise_clients this will not make sense probably!
    display_notifications = true,
    debug_level = 0,  -- 1: normal debugging, 2: verbose, 3: very verbose.
}

-- A set of default filters, which can be used for cyclefocus.cycle_filters.
cyclefocus.filters = {
    -- Filter clients on the same screen.
    same_screen = function (c, source_c)
        return (c.screen or capi.mouse.screen) == source_c.screen
    end,

    same_class = function (c, source_c)
        return c.class == source_c.class
    end,

    common_tag  = function (c, source_c)
        if c == source_c then
            return true
        end
        cyclefocus.debug("common_tag_filter\n"
            .. cyclefocus.get_object_name(c) .. " <=> " .. cyclefocus.get_object_name(source_c), 2)
        for _, t in pairs(c:tags()) do
            for _, t2 in pairs(source_c:tags()) do
                if t == t2 then
                    cyclefocus.debug("Filter: client shares tag '"
                        .. cyclefocus.get_object_name(t)
                        .. " with " .. cyclefocus.get_object_name(c))
                    return true
                end
            end
        end
        return false
    end
}

local ignore_focus_signal = false  -- Flag to ignore the focus signal internally.
local filter_result_cache = {}     -- Holds cached filter results.


-- Debug function. Set focusstyle.debug to activate it. {{{
local debug = function(s, level)
    local level = level or 1
    if not cyclefocus.debug_level or cyclefocus.debug_level < level then
        return
    end
    naughty.notify({
        text = tostring(s),
        timeout = 30,
        font = "monospace 10",
    })
end
cyclefocus.debug = debug  -- Used as reference in the filters above.

local get_object_name = function (o)
    if not o then
        return '[no object]'
    elseif not o.name then
        return '[no object name]'
    else
        return o.name
    end
end
cyclefocus.get_object_name = get_object_name
-- }}}


-- Internal functions to handle the focus history. {{{
-- Based upon awful.client.focus.history.
local history = {
    stack = {}
}
function history.delete(c)
    for k, v in ipairs(history.stack) do
        if v == c then
            table.remove(history.stack, k)
            break
        end
    end
end
function history.add(c)
    -- NOTE: c.name could be nil!
    debug("history.add: " .. get_object_name(c), 2)
    if cyclefocus.filter_focus_history then
        if not cyclefocus.filter_focus_history(c) then
            debug("Filtered! " .. get_object_name(c), 2)
            return true
        end
    end
    -- Remove the client if its in the stack
    history.delete(c)
    -- Record the client has latest focused
    table.insert(history.stack, 1, c)
end
-- }}}

-- Connect to signals. {{{
-- Add clients that got focused to the history stack,
-- but not when we are cycling through the clients ourselves.
client.connect_signal("focus", function (c)
    if ignore_focus_signal then
        debug("Ignoring focus signal: " .. get_object_name(c), 3)
        return false
    end
    history.add(c)
end)

client.connect_signal("manage", function (c, startup)
    if ignore_focus_signal then
        debug("Ignoring focus signal (manage): " .. get_object_name(c), 2)
        return false
    end
    history.add(c)
end)
client.connect_signal("unmanage", function (c)
    history.delete(c)
end)
-- }}}

-- Raise a client (does not include focusing).
-- NOTE: awful.client.jumpto also focuses the screen / resets the mouse.
-- See https://github.com/blueyed/awesome-cyclefocus/issues/6
-- Based on awful.client.jumpto, without the code for mouse.
local raise_client = function(c)
    -- Try to make client visible, this also covers e.g. sticky
    local t = c:tags()[1]
    if t and not c:isvisible() then
        awful.tag.viewonly(t)
    end
    c:raise()
end

-- Main function.
cyclefocus.cycle = function(startdirection, _args)
    local args = awful.util.table.join(awful.util.table.clone(cyclefocus), _args)
    local modifier = args.modifier or 'Alt_L'
    local keys = args.keys or {'Tab', 'ISO_Left_Tab'}
    local shift = args.shift or 'Shift'
    -- cycle_filters: different from filter_focus_history!
    local cycle_filters = args.cycle_filters or cyclefocus.cycle_filters

    -- Support single filter.
    if args.cycle_filter then
        cycle_filters = awful.util.table.clone(cycle_filters)
        table.insert(cycle_filters, args.cycle_filter)
    end

    -- Set flag to ignore any focus events while cycling through clients.
    ignore_focus_signal = true

    -- Internal state.
    local orig_client = capi.client.focus  -- Will be jumped to via Escape (abort).
    local idx = 1                          -- Currently focused client in the stack.

    local notifications = {}

    --- Helper function to get the next client.
    -- @param direction 1 (forward) or -1 (backward).
    -- @return client or nil and current index in stack.
    local get_next_client = function(direction, idx, stack)
        local startidx = idx
        local stack = stack or history.stack

        local nextc

        debug('get_next_client: #' .. idx .. ", dir=" .. direction .. ", start=" .. startidx, 2)
        for _ = 1, #stack do
            debug('find loop: #' .. idx .. ", dir=" .. direction, 3)

            idx = idx + direction
            if idx < 1 then
                idx = #stack
            elseif idx > #stack then
                idx = 1
            end
            nextc = stack[idx]

            if nextc then
                -- Filtering.
                if cycle_filters then
                    -- Get and init filter cache data structure.
                    local get_cached_filter_result = function(f, a, b)
                        local b = b or false  -- handle nil
                        if filter_result_cache[f] == nil then
                            filter_result_cache[f] = { [a] = { [b] = { } } }
                            return nil
                        elseif filter_result_cache[f][a] == nil then
                            filter_result_cache[f][a] = { [b] = { } }
                            return nil
                        elseif filter_result_cache[f][a][b] == nil then
                            return nil
                        end
                        return filter_result_cache[f][a][b]
                    end
                    local set_cached_filter_result = function(f, a, b, value)
                        local b = b or false  -- handle nil
                        get_cached_filter_result(f, a, b)  -- init
                        filter_result_cache[f][a][b] = value
                    end

                    -- Apply filters, while looking up cache.
                    for _k, filter in pairs(cycle_filters) do
                        filter_result = get_cached_filter_result(filter, nextc, args.initiating_client)
                        if filter_result ~= nil then
                            if not filter_result then
                                nextc = false
                                break
                            end
                        else
                            local result = filter(nextc, args.initiating_client)
                            set_cached_filter_result(filter, nextc, args.initiating_client, result)
                            if not result then
                                debug("Filtering/skipping client: " .. get_object_name(nextc), 3)
                                nextc = false
                                break
                            end
                        end
                    end
                end
                if nextc then
                    -- Found client to switch to.
                    break
                end
            end
        end
        debug("get_next_client returns: " .. get_object_name(nextc) .. ', idx=' .. idx, 2)
        return nextc, idx
    end

    local first_run = true
    local nextc
    capi.keygrabber.run(function(mod, key, event)
        -- Helper function to exit out of the keygrabber.
        -- If a client is given, it will be jumped to.
        local exit_grabber = function (c)
            debug("exit_grabber: " .. get_object_name(c), 2)
            if c then
                -- NOTE: awful.client.jumpto(c) resets mouse.
                capi.client.focus = c
                raise_client(c)
                history.add(c)
            end
            if notifications then
                for _, v in pairs(notifications) do
                    naughty.destroy(v)
                end
            end
            ignore_focus_signal = false
            capi.keygrabber.stop()
            return true
        end

        debug("grabber: mod: " .. table.concat(mod, ',')
            .. ", key: " .. tostring(key)
            .. ", event: " .. tostring(event)
            .. ", modifier: " .. tostring(modifier), 3)

        -- Abort on Escape.
        if key == 'Escape' then
            return exit_grabber(orig_client)
        end

        -- Direction (forward/backward) is determined by status of shift.
        local direction = awful.util.table.hasitem(mod, shift) and -1 or 1

        if event == "release" and key == modifier then
            -- Focus selected client when releasing modifier.
            -- When coming here on first run, the trigger was pressed quick and we need to fetch the next client while exiting.
            if first_run then
                nextc, idx = get_next_client(direction, idx)
            end
            return exit_grabber(nextc)
        end

        -- Ignore any "release" events and unexpected keys, except for the first run.
        if not first_run then
            if not awful.util.table.hasitem(keys, key) then
                debug("Ignoring unexpected key: " .. tostring(key), 1)
                return true
            end
            if event == "release" then
                return true
            end
        end
        first_run = false

        nextc, idx = get_next_client(direction, idx)
        if not nextc then
            return exit_grabber()
        end

        -- Focus client.
        if args.focus_clients then
            capi.client.focus = nextc
        end

        -- Raise client.
        if args.raise_clients then
            raise_client(nextc)
        end

        if not args.display_notifications then
            return true
        end

        -- Create notification with index, name and screen.
        local do_notification_for_idx_offset = function(offset, c, idx)  -- {{{
            -- TODO: make this configurable using placeholders.
            local naughty_args = {}
            -- .. ", [tags " .. table.concat(tags, ", ") .. "]"

            -- Get naughty preset from naughty_preset, and callbacks.
            naughty_args.preset = awful.util.table.clone(args.naughty_preset)

            -- Callback.
            local args_for_cb = { client=c, offset=offset, idx=idx, total=#history.stack }
            local preset_for_offset = args.naughty_preset_for_offset
            local preset_cb = preset_for_offset[tostring(offset)]
            -- Callback for all.
            if preset_for_offset.default then
                preset_for_offset.default(naughty_args.preset, args_for_cb)
            end
            -- Callback for offset.
            if preset_cb then
                preset_cb(naughty_args.preset, args_for_cb)
            end

            -- Replace previous notification, if any.
            if notifications[tostring(offset)] then
                naughty_args.replaces_id = notifications[tostring(offset)].id
            end

            notifications[tostring(offset)] = naughty.notify(naughty_args)
        end  -- }}}

        -- Get clients before and after currently selected one.
        local prevnextlist = awful.util.table.clone(history.stack)  -- Use a copy, entries will get nil'ed.
        local _idx = idx

        local dlist = {}  -- A table with offset => stack index.

        dlist[0] = _idx
        prevnextlist[_idx] = false

        -- Build dlist for both directions, depending on how many entries should get displayed.
        for _,dir in ipairs({1, -1}) do
            _idx = dlist[0]
            local n = dir == 1 and args.display_next_count or args.display_prev_count
            for i = 1, n do
                local _i = i * dir
                _, _idx = get_next_client(dir, _idx, prevnextlist)
                if _ then
                    dlist[_i] = _idx
                end
                prevnextlist[_idx] = false
            end
        end

        -- Sort the offsets.
        local offsets = {}
        for n in pairs(dlist) do table.insert(offsets, n) end
        table.sort(offsets)

        -- Issue the notifications.
        for _,i in ipairs(offsets) do
            _idx = dlist[i]
            do_notification_for_idx_offset(i, history.stack[_idx], _idx)
            -- Unset client from prevnext list.
            local k = awful.util.table.hasitem(prevnextlist, _c)
            if k then
                -- debug("SHOULD NOT HAPPEN: should be nil", 0)
                prevnextlist[k] = false
            end
        end

        return true
    end)
end


-- A helper method to wrap awful.key.
function cyclefocus.key(mods, key, startdirection, _args)
    local mods = mods or {modkey} or {"Mod4"}
    local key = key or "Tab"
    local startdirection = startdirection or 1
    local args = _args or {}
    args.keys = args.keys or {key}
    args.mods = args.mods or mods

    return awful.key(mods, key, function(c)
        args.initiating_client = c  -- only for clientkeys, might be nil!
        cyclefocus.cycle(startdirection, args)
    end)
end

return cyclefocus
