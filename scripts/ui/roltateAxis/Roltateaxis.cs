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
	private float _size = 1.0f;
	
	public override void _Process(double delta)
	{
		base._Process(delta);
		try
		{
			
			Vector3 bombRotation = (Vector3)BombNode.Call("GetBombRotation") + new Vector3(0, -0.60f, 0) ;
			GlobalRotation = bombRotation;
			//GD.Print("Roltateaxis bombRotation: " + bombRotation);
		}
		catch (Exception _) // what is type cast exception
		{
			return;
		}
	}

	public override void _Ready()
	{
		base._Ready();
		// SetupRay();
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
	// rn cant be smaller than .01 in size (easy fix)
	private void CreateButtons(float size)
	{
		
		for (int i = 0; i < 6; i++)
		{
			var area = new Area3d();
			var shape = new CollisionShape3D();
			var box = new BoxShape3D();
			switch ((Sides)i)
			{
				case Sides.Top:
					box.Size = new Vector3(size, 0.01f, size);
					shape.Position = Vector3.ModelTop;
					area.Name = "Top (+y)";
					break;
				case Sides.Bottom:
					box.Size = new Vector3(size, 0.01f, size);
					shape.Position = Vector3.ModelBottom;
					area.Name = "Bottom (-y)";
					break;
				case Sides.Left:
					box.Size = new Vector3(0.01f, size, size);
					shape.Position = Vector3.ModelLeft;
					area.Name = "Left (+x)";
					break;
				case Sides.Right:
					area.Name = "Right (-x)";
					box.Size = new Vector3(0.01f, size, size);
					shape.Position = Vector3.ModelRight;
					break;
				case Sides.Front:
					area.Name = "Front (+z)";
					box.Size = new Vector3(size, size, 0.01f);
					shape.Position = Vector3.ModelFront;
					break;
				case Sides.Back:
					area.Name = "Back (-z)";
					box.Size = new Vector3(size, size, 0.01f);
					shape.Position = Vector3.ModelRear;
					break;
			}

			shape.Position *= size / 2;
			area.Name += " Face";
			shape.Name = area.Name.ToString().Substring(0,area.Name.ToString().Length - 9) + "Face Shape";
			shape.Shape = box;
			area.AddChild(shape);
			AddChild(area);
			
		}
	}


	
	// private void SetupRay()
	// {
	// 	_ray = new RayCast3D();
	// 	_ray.CollideWithBodies = true;
	// 	_ray.Enabled = true;
	// 	_ray.Name = "ClickRay";
	// 	AddChild(_ray);
	// 	_ray = GetNode<RayCast3D>("ClickRay");
	// }
	//
	// public override void _Input(InputEvent @event)
	// {
	// 	base._Input(@event);
	// 	if (@event is InputEventMouseButton eventMouseButton && eventMouseButton.Pressed &&
	// 		eventMouseButton.ButtonIndex == MouseButton.Left)
	// 	{
	// 		Camera3D camera = GetParent<Camera3D>();
	// 		var from = camera.ProjectRayOrigin(eventMouseButton.Position);
	// 		var to = from + camera.ProjectRayNormal(eventMouseButton.Position) * RayLength;
	// 		_ray.Position = from;
	// 		_ray.TargetPosition = to;
	// 		_ray.ForceRaycastUpdate();
	// 		GD.Print($"from {from} to {to}");
	// 		GD.Print($"Mouse position: {eventMouseButton.Position}");
	// 		if (_ray.IsColliding())
	// 		{
	// 			DebugDraw3D.DrawRay(_ray.Position, _ray.TargetPosition, 5f, Colors.Green, 10000000F);
	// 			var collider = _ray.GetCollider();
	// 			GD.Print("ray collided with " + collider.Get("Name"));
	// 			if (collider is Roltateaxis)
	// 			{
	// 				GD.Print("Roltateaxis clicked");
	// 				GetParent<bomb>().Call("SetLockedAxis", this.Name);
	// 			}
	// 		}
	// 		else
	// 		{
	// 			DebugDraw3D.DrawRay(_ray.Position, _ray.TargetPosition, 5f, Colors.Red, 10000000F);
	// 		}
	// 	}
	// }
	
}
