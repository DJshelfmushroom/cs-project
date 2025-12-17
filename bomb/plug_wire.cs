using Godot;
using System;
using System.Diagnostics;


public partial class plug_wire : Node3D
{
	public RayCast3D Ray;

	private NodePath path;

	private Node3D pnode;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Ray = GetNode("RayCast3D") as RayCast3D;
		GD.Print($"ray:{Ray}");
		path = (NodePath)GetMeta("link");
		GD.Print($"path:{path}");
		pnode = GetNode(path) as Node3D;
		// Ray.TargetPosition = pnode.Position;

	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//DebugDraw3D.DrawLine(Ray.GlobalPosition, pnode.GlobalPosition, Colors.Blue);
		DebugDraw3D.DrawPoints([GetNode<Node3D>("../../bomb_instance/Node3D").GlobalPosition], DebugDraw3D.PointType.TypeSphere, 0.01f, Colors.Green);
	}
	
}
