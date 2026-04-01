using System;
using System.Collections.Generic;
using System.Linq;
using csproject.scripts.puzzles.OperationSub;
using static csproject.scripts.core.Utils.Logger;
using csproject.scripts.core;
using Godot;
using Microsoft.VisualBasic.CompilerServices;
using Utils = csproject.scripts.core.Utils;

// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	public const int id = 14; // to reference in GDScript
	
	// private OperationPath2D _operation;
	public override void _Ready()
	{
		GenerateLine();
		
	}
#if DEBUG
	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event.IsActionPressed("key_x"))
		{
			Log("refresh",  this, color: LogColors.GREEN);
			GenerateLine();
		}
	}
#endif

	private void GenerateLine() 
	{
		OperationPath2D operation = new OperationPath2D(new Vector2(500, 500), new Vector2(500, 500),
			15,new Vector2(50, 200), this);
		operation:
		foreach (Node child in GetChildren())
		{
			RemoveChild(child);
			child.QueueFree();
		}

		// try
		// {
		
		if (operation.GenerateCurve())
		{
			goto place;
		}
		else
		{
			Log("uh oh (rerunning)", this, LogType.Error);
			goto operation;
		}
		place:
		Log("Passed", this, color: LogColors.GREEN);
	}
	
	public void Success()
	{
		Log("Success", this, color: LogColors.GREEN);
	}
	
	public void Failure()
	{
		Utils.GetBombNode(this).Call("Strike");
	}
}

class OperationPath2D(
	Vector2 center,
	Vector2 size,
	int pointCount,
	Vector2 pointSpaceRange,
	Node owner,
	float lineWidth = 5,
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
	
	
	// generates a curve that also happens to render if you treat it correctly. 
	public bool GenerateCurve()
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
		while (i < pointCount) //TODO make size work, figure out a way to optimize, implement startpoint, patch infinite looping
		{
			int pointDist = (int)(rRange * random.NextSingle() + rBottom);
			Vector2 dir;

			// curve_roll:
			do
			{
				attempts++;
				if (attempts > AttemptThreshold)
				{
					// throw new StackOverflowException("");
					return false;
				}
				
				do
				{
					int d1 = random.Next(0, 3) - 1;
					dir = new Vector2(d1, d1 == 0 ? AbsoluteCeiling(random.NextSingle() - .5f) : 0);
					// Utils.Log($"dir: {dir}", owner);
				} while (dir.IsEqualApprox(-1 * prevDir) 
						 || dir.IsEqualApprox(prevDir)
						 );
				
				// Utils.Log($"i: {i}", owner);
				// Utils.Log($"point list len: {points.Count}", owner);
				var newPoint = dir * pointDist + points[i - 1];
				
				if (newPoint.X > _size.X / 2 || newPoint.X < 0 - _size.X / 2 ||
					newPoint.Y >  _size.Y / 2 || newPoint.Y < 0 - _size.Y / 2)
				{
					Log("out of bounds", owner);
					continue;
				}
				
				var polyline = Geometry2D.OffsetPolyline([points[i - 1], newPoint], lineWidth, endType: Geometry2D.PolyEndType.Joined);
				if (polyline.Count == 0) continue; 
				var collision = new CollisionPolygon2D();
				collision.Polygon = polyline.ToArray().First();
				OperationArea2D.Section lineSection;
				var color = Colors.Aquamarine;
				if (i == 1) 
				{lineSection = OperationArea2D.Section.First;
					color = Colors.GreenYellow;
				}
				else if (i == pointCount - 1) 
				{lineSection = OperationArea2D.Section.Last;
					color = Colors.Coral;
				}
				else lineSection = OperationArea2D.Section.Middle;
				
				var area = new OperationArea2D(lineSection);
				area.color = color;
				area.AddChild(collision);
				owner.AddChild(area);
				area.InputPickable = true;
				area.QueueRedraw();

				var rayOffset = Vector2.Zero;
				Log("Ray section", owner);
				raycast:
				Log("Ray offset: " + rayOffset, owner);
				
				var ray = new RayCast2D();
				ray.GlobalPosition = points[i - 1] + rayOffset;
				// ray.Position = Vector2.Zero;
				ray.TargetPosition = newPoint - points[i - 1] + rayOffset;
				// Utils.Log($"pos: {ray.GlobalPosition}, targ: {ray.TargetPosition}", owner);
				ray.CollideWithBodies = false;
				ray.CollideWithAreas = true;
				ray.Enabled = true;
				ray.ExcludeParent = true;
				ray.HitFromInside = false;
				owner.AddChild(ray);
				ray.ForceRaycastUpdate();
				// attempts++;
				if (ray.IsColliding())
				{
					// Utils.Log($"Collision: {((Node2D)ray.GetCollider()).Name}, position: {ray.GetCollisionPoint()}", owner);
					if (ray.GetCollider() is Area2D && owner.GetChildren().Contains(ray.GetCollider()))
					{
						area.QueueFree();
						// ray.QueueFree();
						// i--;
						continue;
					}
				}
				
				var rayShift = InvertVec2(dir) * lineWidth/2;
				if (rayOffset == Vector2.Zero)
				{
					rayOffset = rayShift;
					goto raycast;
				}
				if (rayOffset == rayShift)
				{
					rayOffset = -rayShift;
					goto raycast;
				}

				// Utils.Log($"attempts: {attempts}", owner, color: "blue");
				points.Add(newPoint);
				Log($"i: {i}", owner);
				Log($"points: {points.Count}", owner);
				prevDir = dir;
				owner.RemoveChild(ray);
				ray.QueueFree();
				i++;
				attempts = 0;
				break;
			} while (true);
		}

		foreach (Node child in owner.GetChildren())
		{
			if (child is OperationArea2D)
			{
				((Node2D)child).Position += _center;
			}
		}
			
		return true;
	}


	private static Vector2 InvertVec2(Vector2 vec)
	{
		return new Vector2(vec.Y, vec.X);
	}

	private static int AbsoluteCeiling(float i)
	{    
		return (int)(Math.Sign(i) * Math.Ceiling(MathF.Abs(i)));
	}
}
