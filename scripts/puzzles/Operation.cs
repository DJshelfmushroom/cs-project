using System;
using System.Collections.Generic;
using csproject.scripts.core;
using Godot;
// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	private OperationPath2D operation;
	override public void _Ready()
	{
		operation = new OperationPath2D(new Vector2(500, 500), new Vector2(500, 500),
			15,new Vector2(50, 200));
		Path2D curve = operation.GeneratePath();
		
		Line2D line = new Line2D();
		line.Points = curve.GetCurve().GetBakedPoints();
		line.Width = 5;
		
		AddChild(line);
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event.IsActionPressed("key_x"))
		{
			Utils.Log("refresh",  this);
			foreach (Node child in this.GetChildren())
			{
				this.RemoveChild(child);
			}
			Path2D curve = operation.GeneratePath();
		
			Line2D line = new Line2D();
			line.Points = curve.GetCurve().GetBakedPoints();
			line.Width = 5;
		
			AddChild(line);
			
		}
	}
}

class OperationPath2D(
	Vector2 center,
	Vector2 size,
	int pointCount,
	Vector2 pointSpaceRange,
	OperationPath2D.StartPoint startPoint = OperationPath2D.StartPoint.BottomLeft)
{
	private Vector2 _center = center;
	private Vector2 _size = size;
	private StartPoint _startPoint = startPoint;

	public enum StartPoint
	{
		TopLeft,
		TopRight,
		BottomLeft,
		BottomRight
	}

	public Path2D GeneratePath()
	{
		var path = new Path2D();
		path.SetCurve(GenerateCurve());
		return path;
	}

	private Curve2D GenerateCurve()
	{
		Curve2D curve = new Curve2D();
		var points = new List<Vector2> { new(0, 0) };
		Random random = new Random();
		int rBottom = (int) pointSpaceRange.X;
		int rRange = Math.Abs((int)pointSpaceRange.Y - (int)pointSpaceRange.X);
		for (int i = 1; i < pointCount; i++) //TODO add raycast check for interferences and re-roll if there are any
		{
			int pointDist = (int)(rRange * random.NextSingle() + rBottom);
			int d1 = random.Next(0, 3) - 1;
			// Utils.Log($"d1 val: {d1}", "scripts/puzzles/Operation");
			Vector2 dir = new Vector2(d1, d1 == 0 ? WierdRound(random.NextSingle() - .5f) : 0);
			Utils.Log($"dir: {dir}", "scripts/puzzles/Operation");
			var newPoint = dir *  pointDist;
			points.Add(newPoint);
		}

		foreach (var point in points)
		{
			curve.AddPoint(point + _center);
		}
		return curve;
	}

	private int WierdRound(float i)
	{
		return (int)(Math.Sign(i) * Math.Ceiling(MathF.Abs(i)));
	}
}
