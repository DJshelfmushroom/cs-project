using Godot;
using System;

public partial class MeshInstance3d : MeshInstance3D
{
	[Export]
	private float _size = 1.0f;
	public override void _Ready()
	{ 
		CreateButtons(_size);
	}

	private void CreateButtons(float size)
	{
		float[] sides = { 0, 1, 2, 3, 4, 5, 6 };
		for (int i = 0; i < 6; i++)
		{
			
		}
	}
}
