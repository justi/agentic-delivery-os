# Design

Generate and update visual design assets per the project's design system.

**Usage:** `/design <description of what to generate>`

## Input

Arguments: $ARGUMENTS

## Process

1. Use the Agent tool to delegate to the `designer` agent with the full arguments.
2. The designer agent will:
   - Discover and load the project's design system
   - Identify affected UI surfaces
   - Implement changes with accessibility and design-token consistency priorities
   - If images are needed, it will further delegate to the `image-generator` agent

## Notes

- Always follows the documented visual design system when it exists.
- Never introduces colors, fonts, or patterns not in the system.
