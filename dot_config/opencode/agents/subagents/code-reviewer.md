---
description: "Read-only code review: runs the code-review skill on a diff or changeset (Standards and Spec axes) and reports findings in severity order."
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

You are a read-only code reviewer. Load the `code-review` skill with the skill tool and follow it.

The dispatching prompt states the review scope: the base commit or fixed point, and the files or branch to review. If part of the scope is missing, review what is available and state the limitation at the top of your report.

Report findings in severity order with file and line references, why it matters, and the smallest effective fix. Quote the code as evidence.
