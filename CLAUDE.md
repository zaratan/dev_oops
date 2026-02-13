# CLAUDE.md — DevOops

## Project Overview

DevOops is a Ruby gem that serves as a shell snippets/scripts manager. It helps developers organize, create, edit, run, and remove custom shell scripts via a CLI. Scripts are stored as JSON configuration files (defining arguments) paired with `.sh` body files.

- **Author:** Denis "Zaratan" Pasin
- **License:** MIT
- **Ruby version:** >= 2.6.0 (configured for 3.0 in `.ruby-version`)
- **CLI framework:** Thor
- **Autoloader:** Zeitwerk

## Repository Structure

```
lib/dev_oops/
├── dev_oops.rb          # Module init, Zeitwerk setup, eager_load
├── version.rb           # VERSION constant (bump for releases)
├── runner.rb            # Thor CLI entry point, dynamic command registration
├── scripts_loader.rb    # Script discovery, config parsing, Thor::Group builders
└── commands/
    ├── edit_script.rb   # Edit script JSON config
    ├── edit_script_sh.rb # Edit script .sh body
    ├── local_install.rb # Create local ./dev_oops directory
    └── remove_script.rb # Remove a script
exe/
└── dev_oops             # Executable entry point
spec/
└── dev_oops_spec.rb     # RSpec tests
templates/
└── empty_script.tt      # JSON template for new scripts
bin/
├── setup                # Install bundle dependencies
├── console              # IRB console with gem loaded
└── local_do             # Local development runner
```

## Development Commands

```bash
# Install dependencies
bundle install
yarn install            # For Prettier Ruby plugin

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Check formatting
yarn prettier -c '**/*.rb'

# Default rake task (runs rspec)
bundle exec rake

# Interactive console
bin/console

# Run locally during development
bin/local_do
```

## CI Checks (must pass before merge)

The CI pipeline (GitHub Actions) runs on Ruby 2.6, 2.7, and 3.0:

1. **Linting:** `bundle exec rubocop`
2. **Tests:** `bundle exec rspec`
3. **Formatting:** `yarn prettier -c '**/*.rb'`

PRs to `main` also verify that `lib/dev_oops/version.rb` has been bumped. Pushes to `main` auto-publish to RubyGems if the version changed.

## Code Conventions

- **Frozen string literals:** Every Ruby file starts with `# frozen_string_literal: true`
- **Module structure:** All code lives under the `DevOops` module. Commands live in `DevOops::Commands`
- **File naming:** `snake_case.rb` — class naming: `PascalCase`
- **Constants:** `UPPER_CASE` (e.g., `GLOBAL_DIR`, `FORBIDDEN_NAMES`)
- **Linter style:** Relaxed Ruby Style + RuboCop Performance + Prettier
- **No monkey patching** in specs (configured in `spec_helper.rb`)

## Architecture Notes

- **Runner** (`runner.rb`): Main Thor CLI class. Registers built-in commands (`edit`, `edit_sh`, `rm`, `install`) and dynamically registers user-defined scripts discovered by `ScriptsLoader`.
- **ScriptsLoader** (`scripts_loader.rb`): Searches for `dev_oops/` directories from the current working directory up to `$HOME`. Loads JSON configs and builds Thor::Group subcommands for each script. Closest-to-cwd wins on name collisions.
- **Script storage:** Global scripts live in `~/.dev_oops/`. Local (project) scripts live in `./dev_oops/`. Each script has a `.json` config and a `.sh` body file.
- **Forbidden script names:** `help`, `install`, `edit`, `edit_sh`, `rm`, `local_install` — reserved for built-in commands.

## Version & Release

- Version is defined in `lib/dev_oops/version.rb`
- Bump the version there for any release
- CI verifies version changes on PRs to `main` and auto-publishes to RubyGems on merge

## Key Dependencies

| Gem | Purpose |
|-----|---------|
| `thor` | CLI framework |
| `zeitwerk` | Autoloading |
| `rspec` | Testing |
| `rubocop` | Linting |
| `prettier` | Code formatting (via Node + Ruby plugin) |
| `pry-byebug` | Debugging |
| `bundler-audit` | Dependency security auditing |
