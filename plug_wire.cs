using Godot;
using System;

public partial class plug_wire : Path3D
{
	public RayCast3D ray;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ray = GetNode<RayCast3D>("RayCast3D");
		ray.Enabled = true;
		GD.Print("test");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
