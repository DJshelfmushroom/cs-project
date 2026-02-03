using Godot;
using System;
using System.Diagnostics;
using System.Net.NetworkInformation;

public partial class Roltateaxis : Node3D
{
	private const float RayLength = 1000.0f;
	private RayCast3D ray;
	[Export] 
	public Node3D BombNode = null;
	
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
				GD.Print("ray collided with " + collider.Get("Name"));
				if (collider is Roltateaxis)
				{
					GD.Print("Roltateaxis clicked");
					GetParent<bomb>().Call("SetLockedAxis", this.Name);
				}
			}
		}
	}
}
