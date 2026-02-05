using Godot;
using System;
using System.Diagnostics;
using System.Net.NetworkInformation;

public partial class Roltateaxis : Node3D
{
	private const float RayLength = 1000.0f;
	private RayCast3D _ray;
	[Export] 
	public Node3D BombNode;
	
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
		SetupRay();
		if (BombNode == null) BombNode = GetNode<Node3D>("../../bomb_instance");
	}

	private void SetupRay()
	{
		_ray = new RayCast3D();
		_ray.CollideWithBodies = true;
		_ray.Enabled = true;
		_ray.Name = "ClickRay";
		AddChild(_ray);
		_ray = GetNode<RayCast3D>("ClickRay");
	}

	public override void _Input(InputEvent @event)
	{
		base._Input(@event);
		if (@event is InputEventMouseButton eventMouseButton && eventMouseButton.Pressed &&
			eventMouseButton.ButtonIndex == MouseButton.Left)
		{
			Camera3D camera = GetParent<Camera3D>();
			var from = camera.ProjectRayOrigin(eventMouseButton.Position);
			var to = from + camera.ProjectRayNormal(eventMouseButton.Position) * RayLength;
			_ray.Position = from;
			_ray.TargetPosition = to;
			_ray.ForceRaycastUpdate();
			GD.Print($"from {from} to {to}");
			GD.Print($"Mouse position: {eventMouseButton.Position}");
			if (_ray.IsColliding())
			{
				DebugDraw3D.DrawRay(_ray.Position, _ray.TargetPosition, 5f, Colors.Green, 10000000F);
				var collider = _ray.GetCollider();
				GD.Print("ray collided with " + collider.Get("Name"));
				if (collider is Roltateaxis)
				{
					GD.Print("Roltateaxis clicked");
					GetParent<bomb>().Call("SetLockedAxis", this.Name);
				}
			}
			else
			{
				DebugDraw3D.DrawRay(_ray.Position, _ray.TargetPosition, 5f, Colors.Red, 10000000F);
			}
		}
	}
}
