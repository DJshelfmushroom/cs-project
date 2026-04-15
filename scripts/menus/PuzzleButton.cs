using Godot;

namespace csproject.scripts.menus;

public partial class PuzzleButton : Button
{
	// ADD YOUR PUZZLE TO THIS
	private string[] puzzleNames =
	[
		"EQUATION PUZZLE", "MEMORY PUZZLE", "SIMON PUZZLE", "REFLEX PUZZLE",
		"NUMERLE PUZZLE", "SEGMENT PUZZLE", "DISABLE PUZZLE", "COLORS PUZZLE",
		"SWITCHES PUZZLE", "YES/NO PUZZLE", "TARGET PUZZLE", "TRACK PUZZLE",
		"SHIFT PUZZLE", "OPERATION PUZZLE", "COLOR THEORY PUZZLE"
	];

	private Control parent;
	public override void _Ready()
	{
		this.GuiInput += OnButtonPressed;
		parent = this.GetParent<Control>();
	}

	public override void _Process(double delta)
	{
		this.Text = puzzleNames[(int)parent.Get("selected_puzzle")];
	}

	private void OnButtonPressed(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseEvent && @event.IsPressed())
		{
			int current = (int)parent.Get("selected_puzzle");
			if (mouseEvent.ButtonIndex == MouseButton.Left)
				parent.Set("selected_puzzle", (current + 1) % puzzleNames.Length);
			else if (mouseEvent.ButtonIndex == MouseButton.Right)
				parent.Set("selected_puzzle", (current - 1 + puzzleNames.Length) % puzzleNames.Length);
		}
	}
}
