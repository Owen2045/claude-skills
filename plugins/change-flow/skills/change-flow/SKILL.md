---
name: change-flow
description: "Workflow for any non-trivial code change: map the blast radius before editing, make the smallest complete change, then dispatch read-only sub-agents to check what the change could break and verify it on the real surface before declaring done. Use when modifying code that spans more than one file, or touches a public function, schema, config, shared module, or data format. Skip for typo, comment, or copy-only edits."
---

# Change Flow

Three gates around every non-trivial change: know what you touch before editing, change the minimum, and have a fresh pair of eyes prove it safe before you say done.

**Non-trivial** means any of: more than one file; a public or exported function, type, or signature; a schema, migration, wire format, or config key; a module other code imports. Anything else, just do it.

## 1. Scope (before any edit)

1. Read the task and the code it touches. Read enough to explain how the current code behaves, not just where the line is.
2. List every place the change must reach. Grep for each symbol you change and record:
   - callers and importers
   - tests and fixtures that reference it
   - config, env vars, feature flags
   - exports, public API, serialized data (JSON fields, DB columns, events)
3. Write the list as a short **Scope** block in your reply: `file:line — why it is affected`.
4. If the list exceeds 5 files or crosses a package or service boundary, show the Scope block to the user and wait before editing. Otherwise continue.

For a bug, reproduce it first and only then build the Scope list. Follow the `diagnosing-bugs` skill for the reproduction loop when it is available.

## 2. Change

- Make the smallest change that reaches every item in the Scope list. No unrequested abstraction, option, or "for later" code.
- Fix shared code once at the root cause instead of patching each caller.
- New non-trivial logic (a branch, a loop, a parser, money, security) gets one small test. Follow the `tdd` skill when the user asks for test-first.
- If you discover an affected place that was not in the Scope list, add it to the list. Do not silently widen the change.

## 3. Check (after editing, before saying done)

Dispatch both sub-agents **in parallel, in one message**, with the Agent tool (`subagent_type`: `change-flow:blast-radius` and `change-flow:verifier`). Give each one the same brief:

- the goal of the change, in one sentence
- the Scope block
- the changed files (or `git diff` range)
- how to run the project's tests, if known

| Sub-agent | Job |
|---|---|
| `blast-radius` | Find breakage beyond the diff that grep does not show, and prove the one fact the change is safe because of by running code. |
| `verifier` | Run the real check on the surface the user will hit: tests, the CLI, the endpoint, the script. Report pass or fail with output. |

Both are read-only. They report; you fix.

Rules for the results:
- A confirmed risk gets fixed, then the affected sub-agent runs again on the new diff.
- A risk you decide not to fix goes into the final report with the reason.
- "Inconclusive" or "checked the wrong surface" is not a pass. Say so.
- Do not run a code review in this step. Run `code-review` only when the user asks for a review.

## 4. Report

End with four short sections:

- **Changed**: what changed, `file:line`.
- **Scope**: the final list, including anything added during the change.
- **Proven safe**: the safety fact and how it was proven (the command and its result).
- **Not checked / risks**: what neither sub-agent covered, and any risk left open.

Adapted from pstack's `blast-radius` and `principle-prove-it-works` skills (MIT, https://github.com/cursor/plugins/tree/main/pstack).
