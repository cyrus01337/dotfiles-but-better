# Configurations

This is a house for as many common configurations as possible that I've had to
write out a dozen times, which fatigues me very quickly in a working day. It's
also a thought experiment that I'm trying where I consolidate as much as
possible into a single directory, then symlink whatever is necessary
automatically. Any global updates are made to this repository, then pulled
externally in whatever project depends on this.

It's a thought experiment because I don't know if this is going to be fruitful,
so I'll be trying this out then documenting my findings here.

If there happens to be a configuration that doesn't quite line up with a
project's needs, then I'll just copy it directly and modify as needed. Not
all configurations present are intended to be used in one project or for them
to be used as is, they're just templates with enough sensible defaults to work
for my use cases.

### Setup

This project is intended to be used as a submodule for continuous updates. To
add it to a project:

```sh
git submodule add https://github.com/cyrus01337/configurations.git external/configurations
```

Then any configuration can be referenced when running commands, using CLI tools
or symlinked for direct reference if needed.
