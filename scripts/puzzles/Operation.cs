using System.Linq;
using Godot;
using Godot.NativeInterop;
// ReSharper disable ReturnValueOfPureMethodIsNotUsed

namespace csproject.scripts.puzzles;

public partial class Operation : Node
{
	override public void _Ready()
	{
		new OperationPath2D(new Vector2(), new Vector2(), new Vector2(), 0, 1);
	}
}

partial class OperationPath2D
{
	private Vector2 _start, _end, _size;
	private int _spacing, _pointCount;

	public Path2D GeneratePath(bool render = false) // render is for debugging
	{
		Path2D path = new Path2D();
		path.Curve = GenerateCurve();

		return path;
	}

	private Curve2D GenerateCurve()
	{
		Curve2D curve = new Curve2D();
		Vector2[] points = new Vector2[_pointCount];
		points.Append(_start);
		for (int i = 1; i < _pointCount - 1; i++)
		{
			float t = (float)i / (_pointCount - 1);
			Vector2 point = Vector2.Lerp(_end, t); // i ont even care
			point.X += (float) GD.RandRange(-_size.X / 2, _size.X / 2) * (_spacing / 10f);
			point.Y += (float) GD.RandRange(-_size.Y / 2, _size.Y / 2) * (_spacing / 10f);
			points.Append(point);
		}
		
		points.Append(_end);
		return curve;
	}

	public OperationPath2D(Vector2 start, Vector2 end, Vector2 size, int spacing, int pointCount)
	{
		_start = start;
		_end = end;
		_size = size;
		_spacing = spacing;
		_pointCount = pointCount;
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
	
	
