using Godot;
using System;

public partial class explosion : Node
{
	int frame = 0;
	bool hasExploded = false;
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
			if (((bool)GetNode("..").Get("failed") || (int)GetNode("..").Get("strikes") >= 3) && !hasExploded)
			{
				hasExploded = true;
				foreach (GpuParticles3D child in GetChildren())
				{
					child.Emitting = true;
				}
				AudioStreamPlayer explosionSound = new AudioStreamPlayer();
				GetNode<Node3D>("../bomb_instance").Hide();
				explosionSound.Stream = GD.Load<AudioStreamWav>("res://explosion.wav");
				GetParent().AddChild(explosionSound);
				explosionSound.Playing = true;
				explosionSound.Connect("finished", Callable.From(() => explosionSound.QueueFree()));
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
