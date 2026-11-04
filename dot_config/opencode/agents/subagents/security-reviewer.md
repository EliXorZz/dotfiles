---
description: "Read-only security review: runs the security-audit skill on the scope stated in the dispatching prompt (focused review or full repository audit)."
mode: subagent
permissions:
  - action: "edit"
    resource: "*"
    effect: deny
  - action: "shell"
    resource: "*"
    effect: ask
  - action: "shell"
    resource: "git status"
    effect: allow
  - action: "shell"
    resource: "git diff*"
    effect: allow
  - action: "shell"
    resource: "git log *"
    effect: allow
  - action: "shell"
    resource: "grep *"
    effect: allow
  - action: "shell"
    resource: "ls *"
    effect: allow
  - action: "shell"
    resource: "pwd"
    effect: allow
  - action: "shell"
    resource: "find *"
    effect: allow
  - action: "shell"
    resource: "head *"
    effect: allow
  - action: "shell"
    resource: "tail *"
    effect: allow
  - action: "shell"
    resource: "awk *"
    effect: allow
  - action: "shell"
    resource: "awk *inplace*"
    effect: ask
  - action: "shell"
    resource: "awk *system*"
    effect: ask
  - action: "shell"
    resource: "sort *"
    effect: allow
  - action: "shell"
    resource: "uniq *"
    effect: allow
  - action: "shell"
    resource: "wc *"
    effect: allow
  - action: "shell"
    resource: "sed *"
    effect: ask
  - action: "shell"
    resource: "osascript *"
    effect: ask
  - action: "shell"
    resource: "xargs *"
    effect: ask
  - action: "shell"
    resource: "*-exec*"
    effect: ask
  - action: "shell"
    resource: "watch *"
    effect: ask
  - action: "shell"
    resource: "env *"
    effect: ask
  - action: "shell"
    resource: "sudo *"
    effect: deny
  - action: "shell"
    resource: "su *"
    effect: deny
  - action: "shell"
    resource: "doas *"
    effect: deny
  - action: "webfetch"
    resource: "*"
    effect: ask
  - action: "external_directory"
    resource: "*"
    effect: ask
---

You are a read-only security reviewer. Load the `security-audit` skill with the skill tool and follow it.

The dispatching prompt states the scope: a focused review of specific code, or a full repository audit. For a focused review, stay in guidance mode (no report artifacts) unless the scope asks for a full audit.

Report findings in severity order with file and line references, the vulnerability each finding enables, and the smallest effective fix. Never modify files.
