# Bun Plugin

A comprehensive oh-my-zsh plugin for [Bun](https://bun.sh), the fast all-in-one JavaScript runtime.

## Features

- **Auto-completion**: Cached zsh completions for all bun commands
- **Aliases**: Short aliases for common bun operations
- **Helper Functions**: Advanced wrapper functions for complex workflows
- **Development Tools**: Enhanced development workflow support

## Prerequisites

- [Bun](https://bun.sh) must be installed
- oh-my-zsh

## Installation

1. Clone this plugin to your oh-my-zsh custom plugins directory:
   ```zsh
   git clone https://github.com/yourusername/zsh-custom ~/.oh-my-zsh/custom/plugins/
   ```

2. Add `bun` to your plugins list in `~/.zshrc`:
   ```zsh
   plugins=(... bun)
   ```

3. Reload your shell:
   ```zsh
   source ~/.zshrc
   ```

## Aliases

### Basic Commands
| Alias | Command | Description |
|-------|---------|-------------|
| `b` | `bun` | Main bun command |
| `bi` | `bun install` | Install dependencies |
| `ba` | `bun add` | Add package |
| `bad` | `bun add --dev` | Add dev dependency |
| `br` | `bun remove` | Remove package |
| `bu` | `bun update` | Update dependencies |
| `bx` | `bun x` | Execute package |

### Development
| Alias | Command | Description |
|-------|---------|-------------|
| `bd` | `bun dev` | Start development server |
| `bb` | `bun build` | Build project |
| `bt` | `bun test` | Run tests |
| `bw` | `bun run --watch` | Run with watch mode |
| `bs` | `bun start` | Start application |
| `brun` | `bun run` | Run script |

### Project Management
| Alias | Command | Description |
|-------|---------|-------------|
| `binit` | `bun init` | Initialize new project |
| `bcreate` | `bun create` | Create project from template |
| `blink` | `bun link` | Link package |
| `bunlink` | `bun unlink` | Unlink package |

### Package Manager
| Alias | Command | Description |
|-------|---------|-------------|
| `bpm` | `bun pm` | Package manager commands |
| `bpml` | `bun pm ls` | List installed packages |
| `bpmla` | `bun pm ls --all` | List all packages (including transitive) |
| `bpmc` | `bun pm cache` | Cache operations |
| `bpmcl` | `bun pm cache clean` | Clean package cache |

## Helper Functions

### `bhelp`
Display all available aliases and functions with descriptions.

```zsh
bhelp
```

### `binfo`
Show comprehensive project and bun information including version, dependencies, and available scripts.

```zsh
binfo
```

### `bdev [script]`
Start development server with optional script name (defaults to "dev").

```zsh
bdev          # runs bun run dev
bdev start    # runs bun run start
```

### `badd <packages...> [--dev]`
Add multiple packages with optional dev flag and interactive prompts.

```zsh
badd express typescript --dev
badd react react-dom
```

### `btest [filter]`
Run tests with optional filter/grep pattern.

```zsh
btest                # run all tests
btest "user auth"    # run tests matching pattern
```

### `bwatch [script]`
Run script in watch mode (defaults to "dev").

```zsh
bwatch           # runs bun run --watch dev
bwatch build     # runs bun run --watch build
```

### `bclean`
Clean cache, remove node_modules, and reinstall dependencies.

```zsh
bclean
```

### `bbench <script>`
Run benchmark script.

```zsh
bbench benchmark.js
```

## Examples

### Basic Usage
```zsh
# Install dependencies
bi

# Add packages
ba lodash
bad @types/node

# Start development
bd

# Run tests
bt

# Build for production
bb
```

### Advanced Workflows
```zsh
# Get project info
binfo

# Clean and reinstall
bclean

# Add multiple packages as dev dependencies
badd typescript @types/node ts-node --dev

# Run specific test pattern
btest "api tests"

# Start development with watch mode
bwatch dev
```

### Package Management
```zsh
# List all dependencies
bpml

# Clean cache
bpmcl

# Update all packages
bu
```

## Completion

The plugin automatically generates and caches zsh completions for bun commands. Completions are stored in `$ZSH_CACHE_DIR/completions/_bun` and are regenerated in the background to stay up-to-date.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.