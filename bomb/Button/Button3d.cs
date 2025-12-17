using Godot;
using System;

public partial class Button3d : Node3D
{
	private MeshInstance3D ButtonMesh;
	public override void _Ready() {
		ButtonMesh = new MeshInstance3D();
		ButtonMesh.Mesh = GD.Load<Mesh>("res://bomb/Models/bombButtonMesh.tres");	
		this.AddChild(ButtonMesh);
	}
	
}
