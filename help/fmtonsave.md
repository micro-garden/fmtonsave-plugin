# Format on Save Plugin

**Format on Save** is a plugin that automatically formats source code when
saving a file.  
By default, it supports **Lua** via
[StyLua](https://github.com/JohnnyMorganz/StyLua) and several other languages.
You can also configure custom formatters per filetype using the plugin's
settings.

## Usage

Once installed, this plugin will run the appropriate formatter each time a
supported source file is saved.  
For example, saving a `.lua` file will automatically invoke `stylua` and
reload the formatted content.

No additional commands are required. Just save as usual (`Ctrl-s`).

## Features

- Auto-formats on file save

## Supported Formatters by Default

| Language | Formatter                   | Command                        |
|----------|-----------------------------|--------------------------------|
| Lua      | [StyLua][stylua]            | `stylua`                       |
| Go       | [gofmt][gofmt]              | `gofmt -w`                     |
| C        | [ClangFormat][clang_format] | `clang-format -i`              |
| Python   | [Black][black]              | `black`                        |

All formatters must be available in your `$PATH`.

[stylua]: https://github.com/JohnnyMorganz/StyLua
[gofmt]: https://pkg.go.dev/cmd/gofmt
[clang_format]: https://clang.llvm.org/docs/ClangFormat.html
[black]: https://black.readthedocs.io/

## Dynamic Configuration (via setfmtonsave)

You can dynamically assign a formatter for the current filetype using the
`setfmtonsave` command:

```
setfmtonsave black
setfmtonsave clang-format -i --style=Google
setfmtonsave false # remove formatter
```

This will update the `fmtonsave.formatters` global option automatically.

When you define any custom formatter via `setfmtonsave` or
`fmtonsave.formatters`, the plugin stops using its built-in defaults.
To retain formatting for all desired languages, make sure to include entries
for each of them manually.

## Configuration

You can override the default formatters by setting the `fmtonsave.formatters`
option in your `settings.json`.

This option is a string containing multiple lines, where each line defines a
mapping in the format:

```
<filetype>=<formatter command and arguments>
```

Each line specifies a filetype and the corresponding command (with optional
arguments) to be executed on save.

### Example

```json
{
  "fmtonsave.formatters": "lua=stylua\nc=clang-format -i\ngo=gofmt -w\npython=black"
}
```

Note: You must escape newline characters as `\n` when writing this in
`settings.json`.

### Disabling Formatting

To disable formatting for a specific filetype, use the `setfmtonsave false`
command, or simply remove its line from the setting.
