using System;
using System.Collections.Generic;
using System.Linq;
using csproject.scripts.core;
using Godot;
// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	private OperationPath2D _operation;
	override public void _Ready()
	{
		_operation = new OperationPath2D(new Vector2(500, 500), new Vector2(500, 500),
			15,new Vector2(50, 200), this);
		GenerateLine();
		
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event.IsActionPressed("key_x"))
		{
			Utils.Log("refresh",  this);
			GenerateLine();
		}
	}

	private void GenerateLine() 
	{
		foreach (Node child in this.GetChildren())
		{
			RemoveChild(child);
		}
		Line2D line = new Line2D();
		// place:
		try
		{
			line.Points = _operation.GenerateCurve().GetBakedPoints();
		}
		catch (StackOverflowException)
		{
			goto place;	
		}

		line.Width = 5;
		
		AddChild(line);
		place:
		Utils.Log("uh oh", this, "ERROR");
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
	private const int ATTEMPT_THRESHOLD = 50;

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
		for (int i = 1; i < pointCount; i++) //TODO make size work, figure out a way to optimize
		{
			int pointDist = (int)(rRange * random.NextSingle() + rBottom);
			Vector2 dir;
			int attempts = 0;
			attemptsAbsolute++;

			curve_roll:
			do
			{
				attempts++;
				do
				{
					int d1 = random.Next(0, 3) - 1;
					dir = new Vector2(d1, d1 == 0 ? WierdRound(random.NextSingle() - .5f) : 0);
				} while (dir.IsEqualApprox(-1 * prevDir) || dir.IsEqualApprox(prevDir));

				prevDir = dir;
				// Utils.Log($"dir: {dir}", "scripts/puzzles/Operation");
				var newPoint = dir * pointDist + points[i - 1];
				points.Add(newPoint);

				var polyline = Geometry2D.OffsetPolyline([points[i - 1], newPoint], 5);
				var collision = new CollisionPolygon2D();
				collision.Polygon = polyline.ToArray().First();
				var body = new StaticBody2D();
				body.AddChild(collision);
				owner.AddChild(body);

				var ray = new RayCast2D();
				ray.Position = points[i - 1];
				ray.TargetPosition = newPoint;
				ray.CollideWithBodies = true;
				ray.CollideWithAreas = false;
				ray.Enabled = true;
				ray.ExcludeParent = true;
				owner.AddChild(ray);
				ray.ForceRaycastUpdate();
				if (ray.IsColliding())
				{
					if (ray.GetCollider() is StaticBody2D && owner.GetChildren().Contains(ray.GetCollider()))
					{
						Utils.Log("Collision", owner);
						owner.RemoveChild(ray);
						continue;
					}
				}
				owner.RemoveChild(ray);
				break;
			} while (attempts < ATTEMPT_THRESHOLD);

			if (attempts == ATTEMPT_THRESHOLD)
			{
				attempts -= ATTEMPT_THRESHOLD / 10;
				Utils.Log("attempts at limit", owner ,"WARN");
				pointDist -= pointDist > 10? 10 : 0;
				if (pointDist == 0)
				{
					points.RemoveAt(points.Count - 1);
				}

				goto curve_roll;
			} 
			if (attemptsAbsolute > 50)
			{
				Utils.Log("Attempts past threshold", owner, "ERROR");
				i = 0;
				foreach (var child in owner.GetChildren())
				{
					if (startChildren.Contains(child)) continue;
					owner.RemoveChild(child);
				}

				attemptsAbsolute = -10;
			}

			if (attemptsAbsolute < 0)
			{
				throw new StackOverflowException();
				return null;
			}

		}

		foreach (var child in owner.GetChildren())
		{
			if (startChildren.Contains(child)) continue;
			owner.RemoveChild(child);
		}

		foreach (var point in points)
		{
			curve.AddPoint(point + _center);
		}
		return curve;
	}

	private void RaycastSection(Vector2 from,  Vector2 to)
	{
		var ray = new RayCast2D();
		ray.Position = from;
		ray.TargetPosition = to;
		
		
	}

	private static int WierdRound(float i)
	{
		return (int)(Math.Sign(i) * Math.Ceiling(MathF.Abs(i)));
	}
}
