# Format on Save Plugin

**Format on Save** is a micro editor plugin that automatically formats source
code when saving a file.  
Currently, it supports **Lua** via
[StyLua](https://github.com/JohnnyMorganz/StyLua) and some other languages.

## Supported Formatters (as of version 0.0.0)

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

## Usage

Once installed, this plugin will run the appropriate formatter each time a
supported source file is saved.  
For example, saving a `.lua` file will automatically invoke `stylua` and
reload the formatted content.

No additional commands are required — just save as usual (`Ctrl-s`).

## Features

- Auto-formats on file save
