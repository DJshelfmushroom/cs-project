// using Godot;
//
// namespace csproject.Testing;
//
// public partial class MeshInstance3d : MeshInstance3D
// {
// 	[Export]
// 	private float _size = 1.0f;
// 	public override void _Ready()
// 	{ 
// 		CreateButtons(_size);
// 	}
//
// 	private enum Sides 
// 	{
// 		Top = 0,
// 		Bottom = 1,
// 		Left = 2,
// 		Right = 3,
// 		Front = 4,
// 		Back = 5
// 	}
// 	
// 	// rn cant be smaller than .01 in size (easy fix)
// 	private void CreateButtons(float size)
// 	{
// 		for (int i = 0; i < 6; i++)
// 		{
// 			var area = new Area3d();
// 			var shape = new CollisionShape3D();
// 			var box = new BoxShape3D();
// 			switch ((Sides)i)
// 			{
// 				case Sides.Top:
// 					box.Size = new Vector3(size, 0.01f, size);
// 					shape.Position = Vector3.ModelTop;
// 					area.Name = "Top (+y)";
// 					break;
// 				case Sides.Bottom:
// 					box.Size = new Vector3(size, 0.01f, size);
// 					shape.Position = Vector3.ModelBottom;
// 					area.Name = "Bottom (-y)";
// 					break;
// 				case Sides.Left:
// 					box.Size = new Vector3(0.01f, size, size);
// 					shape.Position = Vector3.ModelLeft;
// 					area.Name = "Left (+x)";
// 					break;
// 				case Sides.Right:
// 					area.Name = "Right (-x)";
// 					box.Size = new Vector3(0.01f, size, size);
// 					shape.Position = Vector3.ModelRight;
// 					break;
// 				case Sides.Front:
// 					area.Name = "Front (+z)";
// 					box.Size = new Vector3(size, size, 0.01f);
// 					shape.Position = Vector3.ModelFront;
// 					break;
// 				case Sides.Back:
// 					area.Name = "Back (-z)";
// 					box.Size = new Vector3(size, size, 0.01f);
// 					shape.Position = Vector3.ModelRear;
// 					break;
// 			}
//
// 			shape.Position *= size / 2;
// 			area.Name += " Face";
// 			shape.Name = area.Name.ToString().Substring(0,area.Name.ToString().Length - 9) + "Face Shape";
// 			shape.Shape = box;
// 			area.AddChild(shape);
// 			AddChild(area);
// 			
// 		}
// 	}
// }
