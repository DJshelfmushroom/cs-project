using Godot;
using System;

public partial class Roltateaxis : Node3D
{
	private const float RayLength = 1000.0f;
	private RayCast3D ray;
	
	public override void _Process(double delta)
	{
		base._Process(delta);
		try
		{
			Vector3 bombRotation = (Vector3)GetNode("../../bomb_instance").Call("GetBombRotation");
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
	}

	private void SetupRay()
	{
		ray = new RayCast3D();
		ray.CollideWithBodies = true;
		ray.Enabled = true;
		ray.Name = "ClickRay";
		AddChild(ray);
		ray = GetNode<RayCast3D>("ClickRay");
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
			
			ray.Position = from;
			ray.TargetPosition = to;
			ray.ForceRaycastUpdate();
			DebugDraw3D.DrawRay(from, to, 5f, Colors.Red, 10000000F);
			GD.Print(ray.Position);
			if (ray.IsColliding())
			{
				var collider = ray.GetCollider();
				if (collider is Roltateaxis)
				{
					GD.Print("Roltateaxis clicked");
					GetParent<bomb>().Call("SetLockedAxis", this.Name);
				}
			}
		}
	}
}
