using Godot;
using System;
using System.Diagnostics;
using System.Net.NetworkInformation;


public partial class Roltateaxis : Node3D
{
	// private const float RayLength = 1000.0f;
	// private RayCast3D _ray;
	[Export] 
	public Node3D BombNode;
	[Export]
	private float _size = .01f;
	private const float _thickness = .00001f;
	
	
	public override void _Process(double delta)
	{
		base._Process(delta);
		try
		{
			
			Vector3 bombRotation = (Vector3)BombNode.Call("GetBombRotation") + new Vector3(0, -0.60f, 0);
			GlobalRotation = bombRotation;
		}
		catch (Exception _) // what is type cast exception
		{
			return;
		}
	}

	public override void _Ready()
	{
		base._Ready();
		if (BombNode == null) BombNode = GetNode<Node3D>("../../bomb_instance");
		CreateButtons(_size);
	}

	
	private enum Sides 
	{
		Top = 0,
		Bottom = 1,
		Left = 2,
		Right = 3,
		Front = 4,
		Back = 5
	}

	private void CreateButtons(float size)
	{
		
		for (int i = 0; i < 6; i++)
		{
			var area = new csproject.scripts.ui.roltateAxis.Side();
			var shape = new CollisionShape3D();
			var box = new BoxShape3D();
			var text = new Label3D();
			switch ((Sides)i)
			{
				case Sides.Top:
					box.Size = new Vector3(size, _thickness, size);
					shape.Position = Vector3.ModelTop;
					area.Name = "Top (+y)";
					break;
				case Sides.Bottom:
					box.Size = new Vector3(size, _thickness, size);
					shape.Position = Vector3.ModelBottom;
					area.Name = "Bottom (-y)";
					break;
				case Sides.Left:
					box.Size = new Vector3(_thickness, size, size);
					shape.Position = Vector3.ModelLeft;
					area.Name = "Left (+x)";
					break;
				case Sides.Right:
					area.Name = "Right (-x)";
					box.Size = new Vector3(_thickness, size, size);
					shape.Position = Vector3.ModelRight;
					break;
				case Sides.Front:
					area.Name = "Front (+z)";
					box.Size = new Vector3(size, size, _thickness);
					shape.Position = Vector3.ModelRear;
					break;
				case Sides.Back:
					area.Name = "Back (-z)";
					box.Size = new Vector3(size, size, _thickness);
					shape.Position = Vector3.ModelFront;
					break;
			}
			
			shape.Position *= size / 1024 - _thickness + .01f;
			// GD.Print(area.Name.ToString().Substring(area.Name.ToString().IndexOf('(') + 2, 1));
			text.Text = area.Name.ToString().Substring(area.Name.ToString().IndexOf('(') + 2, 1);
			area.Name += " Face";
			shape.Name = area.Name.ToString().Substring(0,area.Name.ToString().Length - 9) + "Face Shape";
			shape.Shape = box;

			text.Font = GD.Load<Font>("res://assets/fonts/Urban Shadow Sans Serif.otf");
			text.Billboard = BaseMaterial3D.BillboardModeEnum.Disabled;
			text.Position = shape.Position;
			text.LookAtFromPosition(text.Position, Vector3.Zero);
			text.FontSize = (int) (size * 10000);
			text.PixelSize = .0001f;
			text.SetLayerMaskValue(1, true);
			text.SetLayerMaskValue(2, true);
			area.AddChild(text);
			area.AddChild(shape);
			area.SetShape(shape);
			AddChild(area);
			
		}
	}

	public static StringName GetLookAtMethodName()
	{
		return "SetBombRotationFromSide";
	}
	
	public void SetBombRotationFromSide(Node3D side) // what the hell is this
	{
		
		// GD.Print(side.Position.Rotated(Vector3.Up, Single.Pi * 3 / 2).DirectionTo(Vector3.Up).Dot(Vector3.Right));
		if (Single.Abs(side.Position.Rotated(Vector3.Up, Single.Pi * 3 / 2).DirectionTo(Vector3.Up).Dot(Vector3.Right)) >= 0.01f || Single.Abs(side.Position.Rotated(Vector3.Up, Single.Pi * 3 / 2).DirectionTo(Vector3.Up).Dot(Vector3.Right)) == 0)
		{
			// GD.Print(1);
			BombNode.Call(Node3D.MethodName.LookAtFromPosition, Vector3.Zero, side.Position.Rotated(Vector3.Up, Single.Pi * 3 / 2)); 
		}
		else
		{
			// GD.Print(2);
			BombNode.Call(Node3D.MethodName.LookAtFromPosition, Vector3.Zero, side.Position.Rotated(Vector3.Down, Single.Pi * 3 / 2)); 
			BombNode.Rotate(Vector3.Up, Single.Pi * 2);
		}
		BombNode.Position = new Vector3(0, 0.667f, 0);

	}

}
