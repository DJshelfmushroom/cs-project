using System;
using System.Linq;
using Godot;
using Godot.NativeInterop;
// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	override public void _Ready()
	{
		OperationPath2D operation = new OperationPath2D(new Vector2(200, 500), new Vector2(20, 20), new Vector2(), 5, 10, 30);
		Path2D curve = operation.GeneratePath();
		
		Line2D line = new Line2D();
		line.Points = curve.GetCurve().GetBakedPoints();
		line.Width = 2;
		
		AddChild(line);
	}
}

partial class OperationPath2D
{
	private Vector2 _start, _end, _size;
	private int _spacing, _pointCount, _stepSize;

	public Path2D GeneratePath() // render is for debugging
	{
		Path2D path = new Path2D();
		path.Curve = GenerateCurve();
		return path;
	}

	private Curve2D GenerateCurve()
	{
		Curve2D curve = new Curve2D();
		Vector2[] points = new Vector2[_pointCount];
		points[0] = _start;
		Vector2 previousPoint, newPoint = new Vector2();
		float? angle;
		for (int i = 1; i < _pointCount - 1; i++)
		{
			previousPoint = points[i-1];
			angle = Random.Shared.NextSingle() * MathF.PI * 2;
			newPoint.X = previousPoint.X + MathF.Cos((float)angle) * _stepSize;
			newPoint.Y = previousPoint.Y + MathF.Sin((float)angle) * _stepSize;
			GD.Print($"Generated point {i}: {newPoint}");
			points[i] = (newPoint);
		}
		points[_pointCount - 1] = _end;
		angle = null;
		foreach (Vector2 point in points) 
		{
			GD.Print($"Generated point {point}");
			curve.AddPoint(point);
			
		}
		return curve;
	}

	public OperationPath2D(Vector2 start, Vector2 end, Vector2 size, int spacing, int pointCount, int stepSize)
	{
		_start = start;
		_end = end;
		_size = size;
		_spacing = spacing;
		_pointCount = pointCount;
		_stepSize = stepSize;
	}
//	 DON'T ever let this out
//	public unsafe OperationPath2D(Vector2 start, Vector2 end, Vector2 size, int spacing, int pointCount)
//	{
//		fixed (Vector2* startPtr = &_start, endPtr = &_end, sizePtr = &_size)
//		{
//			fixed (int* spacingPtr = &_spacing, pointCountPtr = &_pointCount)
//			{
//#pragma warning disable CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
//				SetVariables(
//					[(object*)startPtr, (object*)endPtr, (object*)sizePtr, (object*)spacingPtr, (object*)pointCountPtr],
//#pragma warning restore CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
//					[start, end, size, spacing, pointCount]);
//			}
//		}
//	}

//#pragma warning disable CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
//	private static unsafe void SetVariables(object*[] vars, object[] vals)
//#pragma warning restore CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
//	{
//		for (int i = 0; i < vals.Length; i++)
//		{
//			*vars[i] = vals[i];
//			GD.Print($"setVariable() -> {*vars[i]}");
//		}
//
}
	
	
