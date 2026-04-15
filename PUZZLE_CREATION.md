# How to Add a Puzzle to the Bomb

There are **5 files to touch**, in this order:

---

## Step 1 — Create your puzzle script
**Location:** `scripts/puzzles/my_puzzle.gd`

Your script needs these two variables at minimum:
```gdscript
var id = 15        # Next available integer
var completed = false
```

Set `completed = true` when the player solves it. That's the only contract the bomb cares about.

To give a strike on a wrong answer, call this directly:
```gdscript
$"../../..".strikes += 1
```

Use `await get_tree().create_timer(1.0).timeout` or local state flags to prevent spam — that's up to you.

---

## Step 2 — Create your puzzle scene
**Location:** `scenes/puzzles/my_puzzle.tscn`

- Root node: `Node3D`
- Attach your script from Step 1
- Add child nodes for your UI (buttons, labels, etc.)
- Connect button `pressed()` signals to handler methods in your script

---

## Step 3 — Register in `game_selection.gd`
Four parallel arrays must all get a new entry **at the same index**:

```gdscript
var puzzles = [
  ...
  preload("res://scenes/puzzles/my_puzzle.tscn")  # index 14 = id 15
]

var puzzle_scales  = [..., 0.5]  # how big it appears on the bomb
var puzzle_weights = [..., 3  ]  # how often it's picked (higher = more frequent)
var weights_left   = [..., 3  ]  # starts equal to puzzle_weights
```

> **Index = ID - 1.** The puzzle at index 0 is id 1.

---

## Step 4 — Add to the practice menu
**File:** `scripts/menus/puzzle_button.gd`

```gdscript
var puzzle_names = [
  ...,
  "MY PUZZLE"  # must match the count of entries in game_selection.puzzles
]
```

---

## Step 5 — Verify array alignment

| Array | File | Entry |
|---|---|---|
| `puzzles` | `game_selection.gd` | scene preload |
| `puzzle_scales` | `game_selection.gd` | float (size on bomb) |
| `puzzle_weights` | `game_selection.gd` | int (spawn frequency) |
| `weights_left` | `game_selection.gd` | same as weight |
| `puzzle_names` | `puzzle_button.gd` | display string |

All five must have the same length. A mismatch won't error immediately — it'll silently cause wrong puzzles to load or the practice menu to break.
