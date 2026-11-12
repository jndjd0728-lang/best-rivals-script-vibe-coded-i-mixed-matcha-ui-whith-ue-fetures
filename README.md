# Rivals Client UI (Luau)

A small Matcha-inspired Roblox client UI starter written in Luau.

## Install

1. Open your Roblox Studio experience.
2. In Explorer, open **StarterPlayer > StarterPlayerScripts**.
3. Insert a **LocalScript**.
4. Copy the contents of [src/ClientUI.client.lua](src/ClientUI.client.lua) into it.
5. Press **Play** to test.

## Included

- Draggable, minimizable dark/purple UI
- Home, Visuals, and Settings tabs
- RightShift menu toggle
- Client-side camera field-of-view adjustment (50–100 degrees)
- Optional FPS and network ping display

## Scope

This is a normal Roblox Studio LocalScript. It does not use executor-only APIs, inject into another experience, automate combat, alter server state, unlock paid items, or bypass game progression. A LocalScript cannot grant server-owned inventory or unlocks; those must be implemented and validated by the experience's server.

## Compatibility

Test in Roblox Studio's current client. Network ping availability can vary by client; if the stat is unavailable, the counter displays `--`.
