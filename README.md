## RedWire

RedWire is a Godot 4.5 project inspired by Roblox-style bomb defusal minigames. The
repository now follows a cleaner layout so scenes, scripts, and assets stay in predictable
locations and can be moved safely inside the editor without breaking references.

### Project structure

- `assets/`
	- `cursor/` – custom cursor textures.
	- `fonts/` – shared UI fonts.
	- `textures/pack_items/` – loot sprites revealed in `pack_open`.
	- `textures/packs/` – pack preview art for the packs menu.
- `scenes/`
	- `components/` – reusable UI/3D pieces such as line paths and timer scenes.
	- `gameplay/` – container/root scenes (e.g. `game.tscn`).
	- `menus/` – title, packs, tutorials, pause menu, etc.
	- `puzzles/` – minigame scenes plus their tutorials.
- `scripts/`
	- `core/` – autoload singletons and shared managers.
	- `components/` – script counterparts for reusable scenes (timers, lines, etc.).
	- `gameplay/`, `menus/`, `minigames/`, `puzzles/`, `ui/` – feature-specific logic.

Every `res://` reference inside scenes and scripts now targets these folders. When adding
new content, drop GDScript files into the appropriate `scripts/<category>` directory and
place scenes under `scenes/<category>` to keep the structure consistent.

### Running

1. Open the folder in Godot 4.5 (or newer) to import assets.
2. The main scene is configured in `project.godot`, so pressing _Play_ launches the latest
	 gameplay container automatically.
3. If you add assets outside the editor, reimport (or edit the `.import` file) so Godot
	 keeps pointing at the copies under `assets/`.

### Contributing tips

- Move/rename files inside Godot whenever possible; it updates GUIDs for you.
- After reorganizing resources, search for bare `res://*.gd` or `res://*.tscn` references
	to confirm nothing still targets an old location.
- Keep feature-specific resources together (e.g., a new puzzle gets both
	`scenes/puzzles` and `scripts/puzzles` entries) to make future refactors painless.
