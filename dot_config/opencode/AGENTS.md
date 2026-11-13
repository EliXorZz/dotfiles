# Antislop — mandatory skills

Before writing or editing code, load the `antislop` skill with the skill tool and follow it. Load `antislop-code` too when the change touches code comments.

For UI work, also load `antislop-ui` (plus `antislop-layoutmobile` when the layout reflows across screen sizes, and `antislop-human` for contrast, keyboard, and focus). For prose or copy, also load `antislop-copywriting`.

# Code intelligence MCP servers

Code intelligence MCP servers: JetBrains IDEs (`goland` and `phpstorm` today, any IDE server added later) and Serena (language servers, any language). Code intelligence only, never execution.

- Pick the server that matches the project language: `goland` for Go, `phpstorm` for PHP/Laravel (Blade and frontend included), the matching IDE server for any language added later.
- IDE first: in a project covered by an IDE MCP server or Serena, navigate through it (`search_symbol`, `analyze_calls`, `get_symbol_info`, `generate_psi_tree`) instead of walking the tree with grep. Native grep/glob only for literal strings, file names, or the fallback below.
- Serena: activate the current directory as its project at session start (`activate_project`), then work at symbol level: `find_symbol`, `find_referencing_symbols`, `get_symbol_overview`, `get_diagnostics`, symbolic editing and rename. Its basic shell, read and search tools are disabled by the `ide` context: native tools cover those.
- Navigation and code understanding: `search_*`, `analyze_calls`, `get_symbol_info`, `generate_psi_tree`, project, dependency and config introspection (`get_project_modules`, `get_project_dependencies`, `get_composer_dependencies`, `get_php_project_config`), framework helpers (`laravel_idea_*`).
- Refactoring: `rename_refactoring`, quick fixes (`apply_quick_fix`), `reformat_file`.
- Diagnostics: `get_file_problems`, `lint_files` after edits, `get_inspections` for quick-fix detail.
- Never execute through an IDE: no `execute_*`, `build_*`, `xdebug_*`, `invoke_ide_action`, run configurations, terminal commands, or SQL/database tools. Tests, builds and commands run in the shell with the project's own tooling (`go test`, `php artisan test`, `composer`, `make`).
- Tools outside these three categories: do not use.
- If the IDE MCP server is unreachable, fall back to shell lint/typecheck and native tools.
