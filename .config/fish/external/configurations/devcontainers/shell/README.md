# Shell Devcontainer

Devcontainers are a part of container-based development - you have a container
for your development environment and a container for testing a project in
production, both are used in tandem or, with the power of Docker in/outside
Docker, within the same container (whether that is good/bad I leave to your
discretion).

In a way this project acts as boilerplate for future devcontainers I choose to
publicise, and a way for me to use my development environment wherever I please
\- as are the pros of container-based development. There are also cons to this
approach, however, I recommend performing your own research on that matter.

## What is this for?
This acts as a base to setup all relevant tools that my shell configuration
requires, which can be found [here](https://github.com/cyrus01337/shell-configuration).

## Inclusions
- Debian 12 (Bookworm) OS
- `developer` user with home directory
- [`cargo`](https://crates.io/) for binary installation (shared as a build tool in other images)
- [`starship`](https://starship.rs/) for prompt
