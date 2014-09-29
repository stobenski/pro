# Pro themes for Awesome WM 3.5+

![](https://raw.githubusercontent.com/gyrfalco/pro/master/screenshots/pro-preview.png)

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

#### Description

[Cyclefocus](https://github.com/blueyed/awesome-cyclefocus) by **Daniel Hahler**

[Lain](https://github.com/copycat-killer/lain) by **Luke Bonham**

[Wallpapers](https://dribbble.com/shots/1479745-50-Free-Tessellated-Designs) by Justin

#### Requirements

1. [Patched] (fixed bug) (https://github.com/awesomeWM/awesome/pull/39) taglist ([download](https://github.com/gyrfalco/pro/blob/master/patched/taglist.lua))

2. Patched (just one space symbol added in name=" " variable) tasklist ([download](https://github.com/gyrfalco/pro/blob/master/patched/tasklist.lua))

3. For transparent tray we use hack (because of [#1198](https://awesome.naquadah.org/bugs/index.php?do=details&task_id=1198) bug in awesome):
```lua
    theme.bg_systray = "#000000" .. 0.01
```
which causes errors in log/tty1, but everything works well.

For avoiding that errors, just start awesome with errorlog redirection, example from my ~/.xinitrc file:
```sh
    exec awesome 2>> /dev/null
```


