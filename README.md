# KDE ToDo

A minimalist to-do list widget for the KDE Plasma 6 desktop, inspired by the iPhone Reminders widget.

![KDE ToDo in action](docs/demo.gif)

## How it works

- Hover over the widget and click **+** to add a task. Press Enter to save.
- Click the circle to complete a task: it gets struck through and disappears after 2 seconds. Click again within that time to undo.
- Completed tasks are deleted. There is no history.
- Tasks are stored in the widget's configuration and survive reboots.

## Customization

Right-click the widget → **Configure...**:

- **Title**: optional, shown at the top.
- **Icon**: none, flame, zap, star, heart, target or book.
- **Accent color**: orange, blue, green, purple, pink or red.
- **Theme**: dark or light, independent of the system theme.

## Installation

Requires KDE Plasma 6.

```sh
git clone https://github.com/JvCasc/KDE-ToDo.git
cd KDE-ToDo
kpackagetool6 -t Plasma/Applet -i package
```

Then right-click the desktop → **Add Widgets...** → search for **KDE ToDo List**.

### Update

```sh
git pull
kpackagetool6 -t Plasma/Applet -u package
```

If the change doesn't show up, restart Plasma:

```sh
systemctl --user restart plasma-plasmashell
```

### Uninstall

```sh
kpackagetool6 -t Plasma/Applet -r com.jvcasc.kdetodo
```

Removing the widget from the desktop also deletes its tasks.

## Credits

- [Inter](https://rsms.me/inter/) font, SIL OFL 1.1
- [Lucide](https://lucide.dev/) icons, ISC License

## License

GPL-2.0-or-later
