using System;
using System.Collections.Generic;
using System.Linq;
using csproject.scripts.core;
using Godot;
// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
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
}

class OperationPath2D(
	Vector2 center,
	Vector2 size,
	int pointCount,
	Vector2 pointSpaceRange,
	Node owner,
	OperationPath2D.StartPoint startPoint = OperationPath2D.StartPoint.BottomLeft)
{
	private Vector2 _center = center;
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
		int attemptsAbsolute = 0;
		for (int i = 1; i < pointCount; i++) //TODO make size work, figure out a way to optimize, implement startpoint
		{
			int pointDist = (int)(rRange * random.NextSingle() + rBottom);
			Vector2 dir;
			int attempts = 0;
			attemptsAbsolute++;

			// curve_roll:
			do
			{
				attempts++;
				do
				{
					int d1 = random.Next(0, 3) - 1;
					dir = new Vector2(d1, d1 == 0 ? AbsoluteCeiling(random.NextSingle() - .5f) : 0);
					Utils.Log($"dir: {dir}", owner);
				} while (dir.IsEqualApprox(-1 * prevDir) 
						 || dir.IsEqualApprox(prevDir)
						 );

				
				// Utils.Log($"dir: {dir}", "scripts/puzzles/Operation");
				// Utils.Log($"points: {points.Count}", owner);
				Utils.Log($"i: {i}", owner);
				Utils.Log($"point list len: {points.Count}", owner);
				var newPoint = dir * pointDist + points[i - 1];
				
				var polyline = Geometry2D.OffsetPolyline([points[i - 1], newPoint], 5, endType: Geometry2D.PolyEndType.Butt);
				var collision = new CollisionPolygon2D();
				collision.Polygon = polyline.ToArray().First();
				var body = new StaticBody2D();
				body.AddChild(collision);
				owner.AddChild(body);

				var ray = new RayCast2D();
				ray.Position = points[i - 1];
				ray.TargetPosition = newPoint;
				Utils.Log($"pos: {ray.Position}, targ: {ray.TargetPosition}", owner);
				ray.CollideWithBodies = true;
				ray.CollideWithAreas = false;
				ray.Enabled = true;
				ray.ExcludeParent = true;
				ray.HitFromInside = false;
				owner.AddChild(ray);
				ray.ForceRaycastUpdate();
				if (ray.IsColliding())
				{
					Utils.Log($"Collision: {((Node2D)ray.GetCollider()).Name}, position: {ray.GetCollisionPoint()}", owner);
					if (ray.GetCollider() is StaticBody2D && owner.GetChildren().Contains(ray.GetCollider()) && ray.GetCollider() != body)
					{
						body.QueueFree();
						// ray.QueueFree();
						// i--;
						continue;
					}
				}
				points.Add(newPoint);
				prevDir = dir;
				ray.QueueFree();
				break;
			} while (attempts < AttemptThreshold);

			// if (attempts == AttemptThreshold)
			// {
			// 	//attempts -= AttemptThreshold / 5;
			// 	Utils.Log("attempts at limit", owner ,"WARN");
			// 	pointDist -= pointDist > 10? 10 : 0;
			// 	if (pointDist == 0)
			// 	{
			// 		// points.RemoveAt(points.Count - 1);
			// 		// i--;
			// 	}
			//
			// 	goto curve_roll;
			// } 
			// if (attemptsAbsolute > 50)
			// {
			// 	Utils.Log("Attempts past threshold", owner, "ERROR");
			// 	i = 0;
			// 	foreach (var child in owner.GetChildren())
			// 	{
			// 		if (startChildren.Contains(child)) continue;
			// 		owner.RemoveChild(child);
			// 	}
			// 	attemptsAbsolute = -10;
			// 	continue;
			// }
			//
			// if (attemptsAbsolute < 0)
			// {
			// 	throw new StackOverflowException();
			// }

		}
		
		foreach (var child in owner.GetChildren())
		{
			if (startChildren.Contains(child)) continue;
			child.QueueFree();
		}

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
