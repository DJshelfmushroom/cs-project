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
