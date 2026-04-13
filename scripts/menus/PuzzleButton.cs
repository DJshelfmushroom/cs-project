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
        "SHIFT PUZZLE", "OPERATION PUZZLE"
    ];

    private Control parent;
    public override void _Ready()
    {
        this.Pressed += OnButtonPressed;
        parent = this.GetParent<Control>();
    }

    public override void _Process(double delta)
    {
        this.Text = puzzleNames[(int)parent.Get("selected_puzzle")];
    }

    private void OnButtonPressed()
    {
        if ((int)parent.Get("selected_puzzle") < puzzleNames.Length - 1)
        {
            parent.Set("selected_puzzle", (int)parent.Get("selected_puzzle") + 1);
        }
        else
        {
            parent.Set("selected_puzzle", 0);
        }
    }
}