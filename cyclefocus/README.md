<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [awesome-cyclefocus](#awesome-cyclefocus)
	- [Screenshot](#screenshot)
	- [Installation](#installation)
	- [Keybindings](#keybindings)
		- [Example 1: cycle through all windows](#example-1-cycle-through-all-windows)
		- [Example 2: cycle through windows on the same screen and tag](#example-2-cycle-through-windows-on-the-same-screen-and-tag)
			- [`cycle_filters`](#cycle_filters)
			- [Prefefined filters](#prefefined-filters)
		- [Example 3: cycle through clients with the same class](#example-3-cycle-through-clients-with-the-same-class)
	- [Reference](#reference)
		- [Configuration](#configuration)
			- [<a name="settings"></a>Settings](#<a-name=settings><a>settings)
	- [Status](#status)
		- [Notifications](#notifications)
- [Bugs, Feedback and Support](#bugs-feedback-and-support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# awesome-cyclefocus

awesome-cyclefocus is a module/plugin for the [awesome window
manager][], which provides methods to cycle through
the most recently used clients (typically known as Alt-Tab).

It allows to easily filter the list of windows to be cycled through, e.g. by
screen, tags, window class, name/title etc.

## Screenshot

![Screenshot](screenshot.png)

Please note that the graphical aspect needs to be developed, but since people
like screenshots…

## Installation

Create a subdirectory `cyclefocus` in you awesome config directory, e.g.

    cd ~/.config/awesome
    git clone https://github.com/blueyed/awesome-cyclefocus cyclefocus

Then include it from your awesome config file (`~/.config/awesome/rc.lua`),
somewhere at the beginning:

```lua
local cyclefocus = require('cyclefocus')
```

## Keybindings

Then you can define the keybindings.

While you can use it with the `globalkeys`, the `clientkeys` table is required for any
bindings which use `cycle_filters`.

The default for `modkey+Tab` in awesome (3.5.2) is:
```lua
awful.key({ modkey,           }, "Tab",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),
```
You should disable it (e.g. by commenting it), and put your method below (or in the same block).
(However, this would be in the `globalkeys` block, which is only useful for the mapping to cycle
through all windows.)

Here are three methods to setup the key mappings:

### Example 1: cycle through all windows

Setup `modkey+Tab` to cycle through all windows (assuming modkey is
`Mod4`/`Super_L`, which is the default):

```lua
-- modkey+Tab: cycle through all clients.
awful.key({ modkey,         }, "Tab", function(c)
        cyclefocus.cycle(1, {modifier="Super_L"})
end),
-- modkey+Shift+Tab: backwards
awful.key({ modkey, "Shift" }, "Tab", function(c)
        cyclefocus.cycle(-1, {modifier="Super_L"})
end),
```

The first argument to `cyclefocus.cycle` is the starting direction: 1 means
backwards in history (incrementing index for the history stack), -1 means to go
in the opposite direction. `1` is the normal behavior, while `-1` refers to the
shifted version.

The second argument is a table of optional arguments. We need to pass the
modifier being used (as seen by awesome's `keygrabber`) here.

See the `init.lua` file for a full reference, or refer to the [settings section
below](#settings).

### Example 2: cycle through windows on the same screen and tag

There is a helper function `cyclefocus.key`, which can be used instead of
`awful.key` (it is a wrapper):

```lua
-- Alt-Tab: cycle through clients on the same screen.
-- This must be a clientkeys mapping to have source_c available in the callback.
cyclefocus.key({ "Mod1", }, "Tab", 1, {
    -- cycle_filters as a function callback:
    -- cycle_filters = { function (c, source_c) return c.screen == source_c.screen end },

    -- cycle_filters from the default filters:
    cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
    keys = {'Tab', 'ISO_Left_Tab'}  -- default, could be left out
}),
```

The first two arguments are the same as with `awful.key`: a list of modifiers and
the key. Then follows the direction and the list of optional arguments again.
(here the `modifier` argument is not required, because it is given in the first
argument).

#### `cycle_filters`

In this case the `cycle_filters` argument is used, which is a list of filters
to apply while cycling through the focus history: it gets passed a `client`
object, and optionally another `client` object for the source (where the
cycling started).
For the source client to be available, it needs to be an entry in the
`clientkeys` table.

You can pass functions here, or use one of the predefined filters:

#### Prefefined filters

The following filters are predefined, and can be used (as with the example above):

```lua
-- A set of default filters, which can be used for cyclefocus.cycle_filters.
cyclefocus.filters = {
    -- Filter clients on the same screen.
    same_screen = function (c, source_c) return c.screen == source_c.screen end,

    common_tag  = function (c, source_c)
        for _, t in pairs(c:tags()) do
            for _, t2 in pairs(source_c:tags()) do
                if t == t2 then
                    cyclefocus.debug("Filter: client shares tag '" .. t.name .. " with " .. c.name)
                    return true
                end
            end
        end
        return false
    end
}
```

NOTE: this list is likely to change in the beginning. Please consider
submitting any custom filters you come up with to the [Github issue tracker][].

### Example 3: cycle through clients with the same class

The following will cycle through windows, which share the same window class
(e.g. only Firefox windows, when starting from a Firefox window):

```lua
-- Alt-^: cycle through clients with the same class name.
cyclefocus.key({ "Mod1", }, "#49", 1, {
        cycle_filter = function (c, source_c) return c.class == source_c.class end,
        keys = { "°", "^" },  -- the keys to be handled, wouldn't be required if the keycode was available in keygrabber.
}),
cyclefocus.key({ "Mod1", "Shift", }, "#49", -1, {  -- keycode #49 => ^/° on german keyboard, upper left below Escape and next to 1.
        cycle_filter = function (c, source_c) return c.class == source_c.class end,
        keys = { "°", "^" },  -- the keys to be handled, wouldn't be required if the keycode was available in keygrabber.
}),
```

The key argument uses the keycode notation (`#49`) and refers (probably) to the key
below Escape, above Tab and next to the first digit (1).
It should be the same shortcut, as what Ubuntu's Unity uses to cycle through
the windows of a single application.

NOTE: You need to pass the keys this refers to via the `keys` argument. This is
required for the keygrabber to only consider those.
In the example above, `^` and `°` refers to the key on the German keyboard
layout (un-shifted and shifted, i.e. with Shift pressed and released).


## Reference

### Configuration

awesome-cyclefocus can be configured by passing optional arguments to the
`cyclefocus.cycle` or `cyclefocus.key` functions, or by setting defaults, after
loading `cyclefocus`:


#### <a name="settings"></a>Settings

The default settings are:

```lua
cyclefocus = {
    -- Should clients be raised during cycling?
    raise_clients = false,
    -- Should clients be focused during cycling?
    focus_clients = true,

    -- How many entries should get displayed before and after the current one?
    display_next_count = 5,
    display_prev_count = 0,  -- only 0 for prev, works better with naughty notifications.

    -- Preset to be used for the notification.
    naughty_preset = {
        position = 'top_left',
        timeout = 0,
    },

    naughty_preset_for_offset = {
        -- Default callback, which will be applied for all offsets (first).
        default = function (preset, args)
            -- Default font and icon size (gets overwritten for current/0 index).
            preset.font = 'sans 10'
            preset.icon_size = 36
            preset.text = preset.text or cyclefocus.get_object_name(args.client)

            -- Display the notification on the current screen (mouse).
            preset.screen = capi.mouse.screen

            -- Set notification width, based on screen/workarea width.
            local s = preset.screen
            local wa = capi.screen[s].workarea
            preset.width = wa.width * 0.618

            preset.icon = gears.surface.load(args.client.icon) -- using gears prevents memory leaking
        end,

        -- Preset for current entry.
        ["0"] = function (preset, args)
            preset.font = 'sans 14'
            preset.icon_size = 48
            -- Use get_object_name to handle .name=nil.
            preset.text = cyclefocus.get_object_name(args.client)
                    .. " [screen " .. args.client.screen .. "]"
                    .. " [" .. args.idx .. "/" .. args.total .. "] "
            -- XXX: Makes awesome crash:
            -- preset.text = '<span gravity="auto">' .. preset.text .. '</span>'
            preset.text = '<b>' .. preset.text .. '</b>'
        end,

        -- You can refer to entries by their offset.
        ["-1"] = function (preset, args)
            -- preset.icon_size = 32
        end,
        ["1"] = function (preset, args)
            -- preset.icon_size = 32
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
```

You can change them like this:
```lua
cyclefocus = require("cyclefocus")
cyclefocus.debug_level = 2
```

You can also use custom settings when calling `cyclefocus.cycle` or
`cyclefocus.key` via `args`, e.g. to not display notifications when switching
between clients on the same tag:
```lua
cyclefocus.key({ modkey, }, "Tab", 1, {
    cycle_filters = { cyclefocus.filters.common_tag },
    display_notifications = false,
    modifier='Super_L', keys={'Tab', 'ISO_Left_Tab'}
}),
cyclefocus.key({ modkey, "Shift", }, "Tab", 1, {
    cycle_filters = { cyclefocus.filters.common_tag },
    display_notifications = false,
    modifier='Super_L', keys={'Tab', 'ISO_Left_Tab'}
}),
```

## Status

This is to be considered stable: It works for well for me and others.
Internals, default settings and behavior might still change.

I came up with this while dipping my toes in the waters of awesome. If you have
problems, please enable `cyclefocus.debug_level` (goes up to 3) and report your
findings on the [Github issue tracker][].

### Notifications

The notifications while cycling are displayed using `naughty.notify`.
This needs to be replaced and/or improved upon.
The text to be displayed should be made customizable also.

# Bugs, Feedback and Support

You can report bugs and wishes at the [Github issue tracker][].

Pull requests would be awesome! :)

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=blueyed&url=https://github.com/blueyed/awesome-cyclefocus&title=awesome-cyclefocus&language=en&tags=github&category=software)

Bitcoin: 16EVhEpXxfNiT93qT2uxo4DsZSHzNdysSp

[awesome window manager]: http://awesome.naquadah.org/
[Github issue tracker]: https://github.com/blueyed/awesome-cyclefocus/issues
