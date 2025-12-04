using Godot;

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

	public Path2D GeneratePath(bool render = false)
	{
		Path2D path = new Path2D();
		path.Curve = GenerateCurve();

		return path;
	}

	private Curve2D GenerateCurve()
	{
		Curve2D curve = new Curve2D();



		return curve;
	}

	public unsafe OperationPath2D(Vector2 start, Vector2 end, Vector2 size, int spacing, int pointCount)
	{
		fixed (Vector2* startPtr = &_start, endPtr = &_end, sizePtr = &_size)
		{
			fixed (int* spacingPtr = &_spacing, pointCountPtr = &_pointCount)
			{
#pragma warning disable CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
				SetVariables(
					[(object*)startPtr, (object*)endPtr, (object*)sizePtr, (object*)spacingPtr, (object*)pointCountPtr],
#pragma warning restore CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
					[start, end, size, spacing, pointCount]);
			}
		}
	}

#pragma warning disable CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
	private static unsafe void SetVariables(object*[] vars, object[] vals)
#pragma warning restore CS8500 // This takes the address of, gets the size of, or declares a pointer to a managed type
	{
		for (int i = 0; i < vals.Length; i++)
		{
			*vars[i] = vals[i];
			GD.Print($"setVariable() -> {*vars[i]}");
		}
	}
}
	
	