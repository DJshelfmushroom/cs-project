using Godot;
using System;

public partial class Cube : MeshInstance3D
{
	public override void _Ready()
	{ 
		var something=  Mesh.CreateTrimeshShape();
		var something2 = new CollisionShape3D();
		something2.Shape = something;
	}
}
