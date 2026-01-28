using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using Godot;
using Godot.NativeInterop;
// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	override public void _Ready()
	{
		OperationPath2D operation = new OperationPath2D(new Vector2(200, 500), new Vector2(20, 20), Tuple.Create(200,200), 5, 10, 30);
		Path2D curve = operation.GeneratePath();
		
		Line2D line = new Line2D();
		line.Points = curve.GetCurve().GetBakedPoints();
		line.Width = 2;
		
		AddChild(line);
	}
}

class OperationPath2D
{
	private readonly Vector2 _start, _end;
	private readonly Tuple<int,int> _size;
	private readonly int _spacing, _pointCount, _stepSize;
	private const float AngleRange = 120f;
	private const int SnapToAngle = 45;
	private readonly float _angleRangeRadians = (2 * AngleRange + 360 - AngleRange)/360 * MathF.PI * 2f;
	private readonly float _angleSnapRad = SnapToAngle * MathF.PI / 180;

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
		List<Vector2> pointsBack = new List<Vector2>();
		points[0] = _start;
		for (int i = 1; i < _pointCount - 1; i++)
		{
			points[i] = GetNextPointOut(points[i-1], i);
		}
		points[_pointCount - 1] = _start + _end;
		Vector2 point = points[_pointCount-1];
		while (point.DistanceSquaredTo(_end) > _spacing * _spacing)
		{
			point = GetNextPointIn(point);
			pointsBack.Add(point);
		}
		{
			
		}

		foreach (Vector2 index in points) 
		{
			GD.Print($"Generated point {index}");
			curve.AddPoint(index);
		}
		return curve;
	}

	private Vector2 GetNextPointOut(Vector2 currentPoint, int? index = null, bool debug = false)
		
	{
		 Vector2 nextPoint;
		 float angle = Random.Shared.NextSingle() * _angleRangeRadians;
		 if (SnapToAngle > 0)
		 {
			 angle = (float)(Math.Round(angle / _angleSnapRad) * _angleSnapRad);
		 }
		 nextPoint = new Vector2((float)(currentPoint.X + Math.Cos(angle) * _stepSize),(float)(currentPoint.Y + Math.Sin(angle) * _stepSize));
		 if (index.HasValue && !debug)
		 {
			 GD.Print($"Point {index.Value + 1}: {nextPoint}");
		 }

		 if (debug && index.HasValue)
		 {
			 index++;
		 }

		 if (Math.Abs(nextPoint.X - _start.X) > Math.Abs(_size.Item1) || Math.Abs(nextPoint.Y - _start.Y) > Math.Abs(_size.Item2)) 
		 {
			 return GetNextPointOut(currentPoint, index, true);
		 }
		 else
		 {
			 return nextPoint;
		 }
	}
	
	private Vector2 GetNextPointIn(Vector2 currentPoint)
	{
		Vector2 direction = (_end - currentPoint).Normalized();
		Vector2 nextPoint = currentPoint + direction * _stepSize; // dont use this -- autogen
		return nextPoint;
	}
	
	
/// <summary>
/// 
/// </summary>
/// <param name="start">where does it start? this should be the (center?) of the puzzle</param>
/// <param name="end">where does it end up (should be a vector starting at "start" within size)</param>
/// <param name="size">size of the generated puzzle</param>
/// <param name="spacing">max space between lines</param>
/// <param name="pointCount">The number of points it goes out</param>
/// <param name="stepSize">The size of steps between points (essentially inverse if resolution)</param>
	public OperationPath2D(Vector2 start, Vector2 end, Tuple<int,int> size, int spacing, int pointCount, int stepSize)
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
	
	
