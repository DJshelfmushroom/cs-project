using System;
using System.Collections.Generic;
using System.Linq;
using csproject.scripts.core;
using csproject.scripts.puzzles.OperationSub;
using Godot;
using Side = csproject.scripts.ui.roltateAxis.Side;

// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	public const int id = 12; // to reference in GDScript
	
	// private OperationPath2D _operation;
	override public void _Ready()
	{
		GenerateLine();
		
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event.IsActionPressed("key_x"))
		{
			Utils.Log("refresh",  this, color: "green");
			GenerateLine();
		}
	}

	private void GenerateLine() 
	{
		OperationPath2D operation = new OperationPath2D(new Vector2(500, 500), new Vector2(500, 500),
			15,new Vector2(50, 200), this);
		foreach (Node child in GetChildren())
		{
			child.QueueFree();
		}
		Line2D line = new Line2D();
		// place:
		try
		{
			line.Points = operation.GenerateCurve().GetBakedPoints();
		}
		catch (StackOverflowException)
		{
			Utils.Log("uh oh", this, "ERROR");
			goto place;	
		}

		line.Width = 5;
		
		AddChild(line);
		place:
		Utils.Log("Passed", this, color: "green");
	}
	
	private void Success()
	{
		Utils.Log("Success", this, color: "green");
	}
	
	private void Failure()
	{
		Utils.Log("Failure", this, "ERROR");
	}
}

class OperationPath2D(
	Vector2 center,
	Vector2 size,
	int pointCount,
	Vector2 pointSpaceRange,
	Node owner,
	OperationPath2D.StartPoint startPoint = OperationPath2D.StartPoint.BottomLeft)
{
	private readonly Vector2 _center = center;
	private Vector2 _size = size;
	private StartPoint _startPoint = startPoint;
	private const int AttemptThreshold = 50;

	public enum StartPoint
	{
		TopLeft,
		TopRight,
		BottomLeft,
		BottomRight
	}
	
	public Curve2D GenerateCurve()
	{
		var startChildren = owner.GetChildren();
		Curve2D curve = new Curve2D();
		var points = new List<Vector2> { new(0, 0) };
		Random random = new Random();
		int rBottom = (int) pointSpaceRange.X;
		int rRange = Math.Abs((int)pointSpaceRange.Y - (int)pointSpaceRange.X);
		var prevDir = new Vector2(0, 0);
		int attempts = 0;
		int i = 1;
		while (i < pointCount) //TODO make size work, figure out a way to optimize, implement startpoint
		{
			int pointDist = (int)(rRange * random.NextSingle() + rBottom);
			Vector2 dir;

			// curve_roll:
			do
			{
				do
				{
					int d1 = random.Next(0, 3) - 1;
					dir = new Vector2(d1, d1 == 0 ? AbsoluteCeiling(random.NextSingle() - .5f) : 0);
					Utils.Log($"dir: {dir}", owner);
				} while (dir.IsEqualApprox(-1 * prevDir) 
						 || dir.IsEqualApprox(prevDir)
						 );
				
				Utils.Log($"i: {i}", owner);
				Utils.Log($"point list len: {points.Count}", owner);
				var newPoint = dir * pointDist + points[i - 1];
				var polyline = Geometry2D.OffsetPolyline([points[i - 1], newPoint], 5, endType: Geometry2D.PolyEndType.Butt);
				var collision = new CollisionPolygon2D();
				collision.Polygon = polyline.ToArray().First();
				OperationArea2D.Section lineSection;
				if (i == 1) lineSection = OperationArea2D.Section.First;
				else if (i == pointCount - 1) lineSection = OperationArea2D.Section.Last;
				else lineSection = OperationArea2D.Section.Middle;

				var area = new OperationArea2D(lineSection);
				area.AddChild(collision);
				owner.AddChild(area);
				var ray = new RayCast2D();
				ray.GlobalPosition = points[i - 1];
				ray.Position = Vector2.Zero;
				ray.TargetPosition = newPoint - points[i - 1];
				Utils.Log($"pos: {ray.GlobalPosition}, targ: {ray.TargetPosition}", owner);
				ray.CollideWithBodies = false;
				ray.CollideWithAreas = true;
				ray.Enabled = true;
				ray.ExcludeParent = true;
				ray.HitFromInside = false;
				owner.AddChild(ray);
				ray.ForceRaycastUpdate();
				attempts++;
				if (ray.IsColliding())
				{
					Utils.Log($"Collision: {((Node2D)ray.GetCollider()).Name}, position: {ray.GetCollisionPoint()}", owner);
					if (ray.GetCollider() is Area2D && owner.GetChildren().Contains(ray.GetCollider()))
					{
						area.QueueFree();
						// ray.QueueFree();
						// i--;
						if (attempts > AttemptThreshold)
						{
							break;
						}

						continue;
					}
				}
				
				points.Add(newPoint);
				prevDir = dir;
				// ray.QueueFree();
				i++;
				attempts = 0;
				break;
			} while (true);
		}
		
		// foreach (var child in owner.GetChildren())
		// {
		// 	if (startChildren.Contains(child)) continue;
		// 	child.QueueFree();
		// }

		foreach (var point in points)
		{
			curve.AddPoint(point + _center);
		}
		
		return curve;
	}

	private static int AbsoluteCeiling(float i)
	{
		return (int)(Math.Sign(i) * Math.Ceiling(MathF.Abs(i)));
	}
}
