using Godot;
using System;

public partial class explosion : Node
{
	int frame = 0;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		frame++;
		if (frame % 4 == 0)
		{
			if ((bool)GetNode("..").Get("failed"))
			{
				foreach (GpuParticles3D child in GetChildren())
				{
					child.Emitting = true;
				}
				GetNode<Node3D>("../bomb_instance").Hide();

			}
		}
	}

/*	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventKey keyEvent && keyEvent.Keycode == Key.Space)		{
			foreach (GpuParticles3D child in GetChildren())
			{
				child.Emitting = true;
			}
			GetNode<Node3D>("../bomb_instance").Hide();
		}
	}
	*/
}
