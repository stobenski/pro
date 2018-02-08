local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local os, math, string = os, math, string

local taglist_types = {
    "bubbles",        -- 1
    "sticks",         -- 2
}

local chosen_taglist_type = taglist_types[2]
local theme      = {}
--theme.dir        = os.getenv("HOME") .. "/.config/awesome/themes/pro-dark"
theme.dir        = os.getenv("HOME") .. "/code/awesome-pro/themes/pro-dark"

theme.icons      = theme.dir .. "/icons"
theme.wallpaper  = theme.dir .. "/wallpapers/pro-dark-shadow.png"
theme.panel      = "png:" .. theme.icons .. "/panel/panel.png"
theme.font       = "Meslo LGS Regular 10"

theme.fg_normal  = "#888888"
theme.fg_focus   = "#e4e4e4"
theme.fg_urgent  = "#CC9393"

theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#5a5a5a"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = "#343434"

theme.clockgf    = "#d5d5c3"

-- | Borders | --

theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
theme.border_marked = "#000000"

-- | Menu | --

theme.menu_height = 16
theme.menu_width  = 160

-- Notifications
theme.notification_font                         = "Meslo LGS Regular 12"
theme.notification_bg                           = "#5cb85c"
theme.notification_fg                           = "#232323"
theme.notification_border_width                 = 0
theme.notification_border_color                 = "#5cb87c"
theme.notification_shape                        = gears.shape.infobubble
theme.notification_opacity                      = 1
theme.notification_margin                       = 30

-- | Layout | --

theme.layout_floating   = theme.icons .. "/panel/layouts/floating.png"
theme.layout_tile       = theme.icons .. "/panel/layouts/tile.png"
theme.layout_tileleft   = theme.icons .. "/panel/layouts/tileleft.png"
theme.layout_tilebottom = theme.icons .. "/panel/layouts/tilebottom.png"
theme.layout_tiletop    = theme.icons .. "/panel/layouts/tiletop.png"

-- | Taglist | --

theme.taglist_bg_empty    = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/empty.png"
theme.taglist_bg_occupied = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/occupied.png"
theme.taglist_bg_urgent   = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/urgent.png"
theme.taglist_bg_focus    = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/focus.png"
theme.taglist_font        = "Terminus 11"

-- | Tasklist | --

theme.tasklist_font                 = "Terminus 8"
theme.tasklist_disable_icon         = true
theme.tasklist_bg_normal            = "png:" .. theme.icons .. "/panel/tasklist/normal.png"
theme.tasklist_bg_focus             = "png:" .. theme.icons .. "/panel/tasklist/focus.png"
theme.tasklist_bg_urgent            = "png:" .. theme.icons .. "/panel/tasklist/urgent.png"
theme.tasklist_fg_focus             = "#DDDDDD"
theme.tasklist_fg_urgent            = "#EEEEEE"
theme.tasklist_fg_normal            = "#AAAAAA"
theme.tasklist_floating             = ""
theme.tasklist_sticky               = ""
theme.tasklist_ontop                = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- | Widget | --

theme.widget_display   = theme.icons .. "/panel/widgets/display/widget_display.png"
theme.widget_display_r = theme.icons .. "/panel/widgets/display/widget_display_r.png"
theme.widget_display_c = theme.icons .. "/panel/widgets/display/widget_display_c.png"
theme.widget_display_l = theme.icons .. "/panel/widgets/display/widget_display_l.png"

-- | MPD | --

theme.mpd_prev  = theme.icons .. "/panel/widgets/mpd/mpd_prev.png"
theme.mpd_nex   = theme.icons .. "/panel/widgets/mpd/mpd_next.png"
theme.mpd_stop  = theme.icons .. "/panel/widgets/mpd/mpd_stop.png"
theme.mpd_pause = theme.icons .. "/panel/widgets/mpd/mpd_pause.png"
theme.mpd_play  = theme.icons .. "/panel/widgets/mpd/mpd_play.png"
theme.mpd_sepr  = theme.icons .. "/panel/widgets/mpd/mpd_sepr.png"
theme.mpd_sepl  = theme.icons .. "/panel/widgets/mpd/mpd_sepl.png"

-- | Separators | --

theme.spr    = theme.icons .. "/panel/separators/spr.png"
theme.sprtr  = theme.icons .. "/panel/separators/sprtr.png"
theme.spr4px = theme.icons .. "/panel/separators/spr4px.png"
theme.spr5px = theme.icons .. "/panel/separators/spr5px.png"

-- | Clock / Calendar | --

theme.widget_clock = theme.icons .. "/panel/widgets/widget_clock.png"
theme.widget_cal   = theme.icons .. "/panel/widgets/widget_cal.png"

-- | CPU / TMP | --

theme.widget_cpu    = theme.icons .. "/panel/widgets/widget_cpu.png"
-- theme.widget_tmp = theme.icons .. "/panel/widgets/widget_tmp.png"

-- | MEM | --

theme.widget_mem = theme.icons .. "/panel/widgets/widget_mem.png"

-- | FS | --

theme.widget_fs     = theme.icons .. "/panel/widgets/widget_fs.png"
theme.widget_fs_hdd = theme.icons .. "/panel/widgets/widget_fs_hdd.png"

-- | Mail | --

theme.widget_mail = theme.icons .. "/panel/widgets/widget_mail.png"

-- | NET | --

theme.widget_netdl = theme.icons .. "/panel/widgets/widget_netdl.png"
theme.widget_netul = theme.icons .. "/panel/widgets/widget_netul.png"

-- | Misc | --

theme.menu_submenu_icon = theme.icons .. "/submenu.png"

theme.chrome                                    = theme.dir .. "/icons/apps/chrome.png"

-- | Markup | --

local markup = lain.util.markup

-- space3 = markup.font("Terminus 3", " ")
-- space2 = markup.font("Terminus 2", " ")
-- vspace1 = '<span font="Terminus 3"> </span>'
-- vspace2 = '<span font="Terminus 3">  </span>'
-- clockgf = beautiful.clockgf

-- -- | Widgets | --

-- spr = wibox.widget.imagebox()
-- spr:set_image(beautiful.spr)
-- spr4px = wibox.widget.imagebox()
-- spr4px:set_image(beautiful.spr4px)
-- spr5px = wibox.widget.imagebox()
-- spr5px:set_image(beautiful.spr5px)

-- widget_display = wibox.widget.imagebox()
-- widget_display:set_image(beautiful.widget_display)
-- widget_display_r = wibox.widget.imagebox()
-- widget_display_r:set_image(beautiful.widget_display_r)
-- widget_display_l = wibox.widget.imagebox()
-- widget_display_l:set_image(beautiful.widget_display_l)
-- widget_display_c = wibox.widget.imagebox()
-- widget_display_c:set_image(beautiful.widget_display_c)

-- -- | MPD | --

-- prev_icon = wibox.widget.imagebox()
-- prev_icon:set_image(beautiful.mpd_prev)
-- next_icon = wibox.widget.imagebox()
-- next_icon:set_image(beautiful.mpd_nex)
-- stop_icon = wibox.widget.imagebox()
-- stop_icon:set_image(beautiful.mpd_stop)
-- pause_icon = wibox.widget.imagebox()
-- pause_icon:set_image(beautiful.mpd_pause)
-- play_pause_icon = wibox.widget.imagebox()
-- play_pause_icon:set_image(beautiful.mpd_play)
-- mpd_sepl = wibox.widget.imagebox()
-- mpd_sepl:set_image(beautiful.mpd_sepl)
-- mpd_sepr = wibox.widget.imagebox()
-- mpd_sepr:set_image(beautiful.mpd_sepr)

-- mpdwidget = lain.widgets.mpd({
--     settings = function ()
--         if mpd_now.state == "play" then
--             mpd_now.artist = mpd_now.artist:upper():gsub("&.-;", string.lower)
--             mpd_now.title = mpd_now.title:upper():gsub("&.-;", string.lower)
--             widget:set_markup(markup.font("Tamsyn 3", " ")
--                               .. markup.font("Tamsyn 7",
--                               mpd_now.artist
--                               .. " - " ..
--                               mpd_now.title
--                               .. markup.font("Tamsyn 2", " ")))
--             play_pause_icon:set_image(beautiful.mpd_pause)
--             mpd_sepl:set_image(beautiful.mpd_sepl)
--             mpd_sepr:set_image(beautiful.mpd_sepr)
--         elseif mpd_now.state == "pause" then
--             widget:set_markup(markup.font("Tamsyn 4", "") ..
--                               markup.font("Tamsyn 7", "MPD PAUSED") ..
--                               markup.font("Tamsyn 10", ""))
--             play_pause_icon:set_image(beautiful.mpd_play)
--             mpd_sepl:set_image(beautiful.mpd_sepl)
--             mpd_sepr:set_image(beautiful.mpd_sepr)
--         else
--             widget:set_markup("")
--             play_pause_icon:set_image(beautiful.mpd_play)
--             mpd_sepl:set_image(nil)
--             mpd_sepr:set_image(nil)
--         end
--     end
-- })

-- musicwidget = wibox.widget.background()
-- musicwidget:set_widget(mpdwidget)
-- musicwidget:set_bgimage(beautiful.widget_display)
-- musicwidget:buttons(awful.util.table.join(awful.button({ }, 1,
-- function () awful.util.spawn_with_shell(ncmpcpp) end)))
-- prev_icon:buttons(awful.util.table.join(awful.button({}, 1,
-- function ()
--     awful.util.spawn_with_shell("mpc prev || ncmpcpp prev")
--     mpdwidget.update()
-- end)))
-- next_icon:buttons(awful.util.table.join(awful.button({}, 1,
-- function ()
--     awful.util.spawn_with_shell("mpc next || ncmpcpp next")
--     mpdwidget.update()
-- end)))
-- stop_icon:buttons(awful.util.table.join(awful.button({}, 1,
-- function ()
--     play_pause_icon:set_image(beautiful.play)
--     awful.util.spawn_with_shell("mpc stop || ncmpcpp stop")
--     mpdwidget.update()
-- end)))
-- play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1,
-- function ()
--     awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle")
--     mpdwidget.update()
-- end)))

-- -- | Mail | --

-- mail_widget = wibox.widget.textbox()
-- vicious.register(mail_widget, vicious.widgets.gmail, vspace1 .. "${count}" .. vspace1, 1200)

-- widget_mail = wibox.widget.imagebox()
-- widget_mail:set_image(beautiful.widget_mail)
-- mailwidget = wibox.widget.background()
-- mailwidget:set_widget(mail_widget)
-- mailwidget:set_bgimage(beautiful.widget_display)

-- -- | CPU / TMP | --

-- cpu_widget = lain.widgets.cpu({
--     settings = function()
--         widget:set_markup(space3 .. cpu_now.usage .. "%" .. markup.font("Tamsyn 4", " "))
--     end
-- })

-- widget_cpu = wibox.widget.imagebox()
-- widget_cpu:set_image(beautiful.widget_cpu)
-- cpuwidget = wibox.widget.background()
-- cpuwidget:set_widget(cpu_widget)
-- cpuwidget:set_bgimage(beautiful.widget_display)

-- -- | MEM | --

-- mem_widget = lain.widgets.mem({
--     settings = function()
--         widget:set_markup(space3 .. mem_now.used .. "MB" .. markup.font("Tamsyn 4", " "))
--     end
-- })

-- widget_mem = wibox.widget.imagebox()
-- widget_mem:set_image(beautiful.widget_mem)
-- memwidget = wibox.widget.background()
-- memwidget:set_widget(mem_widget)
-- memwidget:set_bgimage(beautiful.widget_display)

-- -- | FS | --

-- fs_widget = wibox.widget.textbox()
-- vicious.register(fs_widget, vicious.widgets.fs, vspace1 .. "${/ avail_gb}GB" .. vspace1, 2)

-- widget_fs = wibox.widget.imagebox()
-- widget_fs:set_image(beautiful.widget_fs)
-- fswidget = wibox.widget.background()
-- fswidget:set_widget(fs_widget)
-- fswidget:set_bgimage(beautiful.widget_display)

-- -- | NET | --

-- net_widgetdl = wibox.widget.textbox()
-- net_widgetul = lain.widgets.net({
--     iface = "eth0",
--     settings = function()
--         widget:set_markup(markup.font("Tamsyn 1", "  ") .. net_now.sent)
--         net_widgetdl:set_markup(markup.font("Tamsyn 1", " ") .. net_now.received .. markup.font("Tamsyn 1", " "))
--     end
-- })

-- widget_netdl = wibox.widget.imagebox()
-- widget_netdl:set_image(beautiful.widget_netdl)
-- netwidgetdl = wibox.widget.background()
-- netwidgetdl:set_widget(net_widgetdl)
-- netwidgetdl:set_bgimage(beautiful.widget_display)

-- widget_netul = wibox.widget.imagebox()
-- widget_netul:set_image(beautiful.widget_netul)
-- netwidgetul = wibox.widget.background()
-- netwidgetul:set_widget(net_widgetul)
-- netwidgetul:set_bgimage(beautiful.widget_display)

-- -- | Clock / Calendar | --

-- mytextclock    = awful.widget.textclock(markup("#232323", space3 .. "%H:%M" .. markup.font("Tamsyn 3", " ")))
-- mytextcalendar = awful.widget.textclock(markup("#232323", space3 .. "%a %d %b"))

-- widget_clock = wibox.widget.imagebox()
-- widget_clock:set_image(beautiful.widget_clock)

-- clockwidget = wibox.widget.background()
-- clockwidget:set_widget(mytextclock)
-- clockwidget:set_bgimage(beautiful.widget_display)

-- local index = 1
-- local loop_widgets = { mytextclock, mytextcalendar }
-- local loop_widgets_icons = { beautiful.widget_clock, beautiful.widget_cal }

-- clockwidget:buttons(awful.util.table.join(awful.button({}, 1,
--     function ()
--         index = index % #loop_widgets + 1
--         clockwidget:set_widget(loop_widgets[index])
--         widget_clock:set_image(loop_widgets_icons[index])
--     end)))

-- Keyboard layout switcher
kbdwidget = wibox.widget.textbox()
kbdwidget.border_width = 1
kbdwidget.border_color = "#232323"
kbdwidget.font = theme.font
kbdwidget:set_markup("<span foreground='#232323'> Eng </span>")


kbdstrings = {[0] = " Eng ",
              [1] = " Rus "}

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    --kbdwidget:set_markup(kbdstrings[layout])
    kbdwidget:set_markup("<span foreground='#232323'>" .. kbdstrings[layout] .. "</span>")
    end
)

-- Chrome_button
chrome_button = awful.widget.button({ image = theme.chrome })
chrome_button:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn("google-chrome-stable") end)
))

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, 1, true)
    
    -- Tags
    --awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
    layout = { awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[3], awful.layout.layouts[5], awful.layout.layouts[5]}
    awful.tag({ "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  " }, s, layout)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 22, bg = theme.panel, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spr5px,
            s.mytaglist,
            spr5px,
            wibox.container.background(wibox.container.margin(wibox.widget { chrome_button, layout = wibox.layout.align.horizontal }, 1, 1), theme.bg_normal),
            
        },
        s.mytasklist, -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            spr5px,
            s.mypromptbox,
            wibox.widget.systray(),
            spr5px,
            spr,
            prev_icon,
            spr,
            stop_icon,
            spr,
            play_pause_icon,
            spr,
            next_icon,
            mpd_sepl,
            musicwidget,
            mpd_sepr,
            spr,
            widget_mail,
            widget_display_l,
            mailwidget,
            widget_display_r,
            spr5px,
            spr,
            widget_cpu,
            widget_display_l,
            cpuwidget,
            widget_display_r,
            spr5px,
            spr,
            widget_mem,
            widget_display_l,
            memwidget,
            widget_display_r,
            spr5px,
            spr,
            widget_fs,
            widget_display_l,
            fswidget,
            widget_display_r,
            spr5px,
            spr,
            widget_netdl,
            widget_display_l,
            netwidgetdl,
            widget_display_c,
            netwidgetul,
            widget_display_r,
            widget_netul,
            spr,
            widget_clock,
            widget_display_l,
            clockwidget,
            widget_display_r,
            spr5px,
            spr,
            s.mylayoutbox,
        },
    }
end

return theme

