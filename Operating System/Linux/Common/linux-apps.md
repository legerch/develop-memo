This file will contains informations related to linux application installations/management

# 1. Desktop file

File `appname.desktop` is used to _register_ installed apps, this is where are set all applications metadatas, those files are generally under:
- `~/.local/share/applications`
- `/usr/share/applications/`

> [!TIP]
> If we search a specific desktop entry file for an app, we can use:
> ```shell
> find / -type f -name "*.desktop" -exec echo $PATH {} \; | grep "appname"
> ```

All documentations can be found at [Desktop Entry Specification][desktop-specs-home] official website ([available keys][desktop-specs-keys] can also be found).

<!-- Links -->
[desktop-specs-home]: https://specifications.freedesktop.org/desktop-entry-spec/latest/
[desktop-specs-keys]: https://specifications.freedesktop.org/desktop-entry-spec/latest/recognized-keys.html