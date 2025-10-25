# Format on Save Plugin for Micro

**Format on Save** is a [micro](https://micro-editor.github.io/) text editor
plugin that automatically formats source code when saving a file.  
By default, it supports **Lua** via
[StyLua](https://github.com/JohnnyMorganz/StyLua) and several other languages.
You can also configure custom formatters per filetype using the plugin's
settings.

See [help/fmtonsave.md](help/fmtonsave.md) for more details.

## Installation

Place the plugin folder in `~/.config/micro/plug/fmtonsave/`, or clone it
directly from the GitHub repository:

```sh
mkdir -p ~/.config/micro/plug
git clone https://github.com/micro-garden/fmtonsave-plugin ~/.config/micro/plug/fmtonsave
```

Alternatively, this plugin is also available through the unofficial plugin
channel:  
https://github.com/micro-garden/unofficial-plugin-channel  
You can install it by adding the channel and then using `plugin install`.

## License

MIT.

## Author

Aki Kareha (aki@kareha.org)
