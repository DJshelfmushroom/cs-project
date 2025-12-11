using Godot;
using System;

public partial class plug_wire : Node3D
{
	public RayCast3D Ray;

	private NodePath path;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Ray = GetNode("../RayCast3D") as RayCast3D;
		GD.Print($"ray:{Ray}");
		path = (NodePath)GetMeta("link");
		GD.Print($"path:{path}");
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
	}
	
}
