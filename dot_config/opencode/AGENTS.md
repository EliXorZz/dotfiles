# Antislop — mandatory skills

Before writing or editing code, load the `antislop` skill with the skill tool and follow it. Load `antislop-code` too when the change touches code comments.

For UI work, also load `antislop-ui` (plus `antislop-layoutmobile` when the layout reflows across screen sizes, and `antislop-human` for contrast, keyboard, and focus). For prose or copy, also load `antislop-copywriting`.

# Code intelligence MCP servers

Code intelligence MCP servers: JetBrains IDEs (`goland` and `phpstorm` today, any IDE server added later) and Serena (language servers, any language). Code intelligence only, never execution.

- Pick the server that matches the project language: `goland` for Go, `phpstorm` for PHP/Laravel (Blade and frontend included), the matching IDE server for any language added later.
- IDE first: in a project covered by an IDE MCP server or Serena, navigate through it (`search_symbol`, `analyze_calls`, `get_symbol_info`, `generate_psi_tree`) instead of walking the tree with grep. Native grep/glob only for literal strings, file names, or the fallback below.
- Serena (v2, REPL interface): call `initial_instructions` at session start to get your Serena session id; the project auto-activates from the working directory. Do symbol-level navigation, reading and refactoring through `serena_repl` in Python: `s.lsp.get_symbols_overview`, `s.lsp.find_symbol`, `s.lsp.find_referencing_symbols`, `s.lsp.rename_symbol`, `s.edit.replace_symbol_body`. Prefer symbol overviews over reading whole files. Use native tools for plain file reads, edits and shell, not Serena's `s.fs`/`s.shell` facades.
- Navigation and code understanding: `search_*`, `analyze_calls`, `get_symbol_info`, `generate_psi_tree`, project, dependency and config introspection (`get_project_modules`, `get_project_dependencies`, `get_composer_dependencies`, `get_php_project_config`), framework helpers (`laravel_idea_*`).
- Refactoring: `rename_refactoring`, quick fixes (`apply_quick_fix`), `reformat_file`.
- Diagnostics: `get_file_problems`, `lint_files` after edits, `get_inspections` for quick-fix detail.
- Never execute through an IDE: no `execute_*`, `build_*`, `xdebug_*`, `invoke_ide_action`, run configurations, terminal commands, or SQL/database tools. Tests, builds and commands run in the shell with the project's own tooling (`go test`, `php artisan test`, `composer`, `make`).
- Tools outside these three categories: do not use.
- If the IDE MCP server is unreachable, fall back to shell lint/typecheck and native tools.
