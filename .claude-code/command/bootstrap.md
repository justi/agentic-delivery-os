# Bootstrap

Entry point for the ADOS bootstrap workflow. Delegates to the `bootstrapper` agent for multi-session project onboarding.

**Usage:** `/bootstrap [<project-name>]`

## Input

- `projectName` (optional): Project name hint passed to the bootstrapper agent.
- Arguments: $ARGUMENTS

## Process

1. Use the Agent tool to delegate to the `bootstrapper` agent, passing the project-name hint if provided.
2. The bootstrapper checks for existing state at `.ai/local/bootstrapper-context.yaml`.
3. If state exists: resume from last phase.
4. If no state: start fresh with repo scan.
5. Follow the multi-session workflow: scan, assess, interview, draft, review, write.

## Notes

- This command runs in the main conversation context (not as a subtask) because the bootstrap workflow is multi-session.
- The bootstrapper agent manages its own persistent state across sessions.
- For the manual adoption path, see `doc/guides/onboarding-existing-project.md`.
