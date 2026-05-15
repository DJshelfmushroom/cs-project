using Godot;
using System;

public partial class Overlay : Control // Ideally this is moved into the ui folder
{
	private Label label;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		label = GetNode<Label>("FPSLabel");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		label.Text = $"{Engine.GetFramesPerSecond()} FPS";
	}
}
