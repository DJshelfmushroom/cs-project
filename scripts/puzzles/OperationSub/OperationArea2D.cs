using System;
using System.Linq;
using Godot;
using static csproject.scripts.core.Utils.Logger;

namespace csproject.scripts.puzzles.OperationSub;

public partial class OperationArea2D(OperationArea2D.Section section) : Area2D
{
	public static int intersections = 0;
	private const string FailMethod = "Failure";
	private const string SuccessMethod = "Success";
	public Color color = Colors.Aquamarine;
	
	
	
	public enum Section
	{
		First,
		Middle,
		Last
	}
	
	public Section GetSection() => section;

	public override void _MouseEnter()
	{
		base._MouseEnter();
		Log("Mouse entered " + section + $" intersect: {intersections}", this);
		if (intersections == 0 && section != Section.First)
		{
			// GetParent().Call(FailMethod);
			((Operation)GetParent()).Failure();
		}

		intersections++;
	}

	public override void _MouseExit()
	{
		Log("Mouse exit " + section + $" intersect: {intersections}", this);
		intersections--;
		if (section == Section.Last)
		{
			try
			{
				// GetParent().Call(SuccessMethod);
				((Operation)GetParent()).Success();
			} catch (Exception)
			{
				Log("OperationArea not child of Operation. Please don't do this. It's not made for this.", this, LogType.Error);
			}
			return;
		}

		if (intersections == 0)
		{
			try
			{
				// GetParent().Call(FailMethod);
				((Operation)GetParent()).Failure();
			} catch (Exception)
			{
				Log("OperationArea not child of Operation. Please don't do this. It's not made for this.", this, LogType.Error);
			}
		} else if (intersections < 0)
		{
			Log("Operation intersection error. (OperationArea line 40)", this, LogType.Error);
		}
	}

	public override void _Draw()
	{
		base._Draw();
		foreach (Node child in GetChildren())
		{
			if (!(child is CollisionPolygon2D))
			{
				continue;
			}
			var childCP = child as CollisionPolygon2D;

			var canvasItem = childCP.GetCanvasItem();
			RenderingServer.CanvasItemClear(canvasItem);
			
			var polygon = childCP.GetPolygon();

			var colors = new Godot.Collections.Array<Color>();
			colors.Resize(polygon.Length);
			colors.Fill(color);
			RenderingServer.CanvasItemAddPolygon(canvasItem, polygon, colors.ToArray());
			// https://github.com/NovaDC/Godot-DrawnArea2D/blob/main/addons/drawn_area_2d/drawn_area_2d.gd#L47
		}
	}
}
