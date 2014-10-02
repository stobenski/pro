# Pro themes for Awesome WM 3.5+

![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro.png)
---

![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-preview.png)
---

##### Alternative tags
![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/alternative-tags.png)
---

### Pro Dark
![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-dark.png)
---

### Pro Medium Dark
![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-medium-dark.png)
---

### Pro Medium Light
![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-medium-light.png)
---

### Pro Light
![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-light.png)
---

### Pro Gotham
![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-gotham.png)

*based on [vim-gotham](https://github.com/whatyouhide/vim-gotham) colorscheme by Andrea Leopardi*

---

#### Description

[Cyclefocus](https://github.com/blueyed/awesome-cyclefocus) by **Daniel Hahler**

[Lain](https://github.com/copycat-killer/lain) by **Luke Bonham**

[Wallpapers](https://dribbble.com/shots/1479745-50-Free-Tessellated-Designs) by **Justin**

---

#### Requirements

1. [Patched](https://github.com/awesomeWM/awesome/pull/39) (fixed bug) taglist ([download](https://github.com/gyrfalco/pro/blob/master/patched/taglist.lua))

2. Patched (just one space symbol added in name=" " variable) tasklist ([download](https://github.com/gyrfalco/pro/blob/master/patched/tasklist.lua))

3. For transparent tray we use hack (because of [#1198](https://awesome.naquadah.org/bugs/index.php?do=details&task_id=1198) bug in awesome):
```lua
    theme.bg_systray = "#000000" .. 0.01
```
which causes errors in log/tty1, but everything works well.

For hiding these errors just start awesome with errorlog redirection, example from my ~/.xinitrc file:
```sh
    exec awesome 2>> /dev/null
```
---

Work in progress: GTK2/3, Firefox, Chromium and Qt theme.

---

##### F.A.Q.

If you have an issue with tray like this:

![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/tray-issue.png)

just restart tray apps or restart (mod4+Ctrl+r) awesome.

