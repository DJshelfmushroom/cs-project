using System;
using System.Collections.Generic;
using System.Linq;
using csproject.scripts.puzzles.OperationSub;
using static csproject.scripts.core.Utils.Logger;
using Godot;
using Godot.Collections;
using Array = Godot.Collections.Array;
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
		OperationPath2D operation = new OperationPath2D(new Vector2(350, 350), new Vector2(500, 500), 
			20,new Vector2(50, 100), this, startPoint:OperationPath2D.StartPoint.BottomLeft);
		operation:
		foreach (Node child in GetChildren())
		{
			if (child is OperationArea2D) {
				RemoveChild(child);
				child.QueueFree();
			}
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
		var area3DContainer = new Node3D();
		AddChild(area3DContainer);
		foreach (var operationArea2D in operation.GetAreas())
		{
			var poly = operationArea2D.GetCollisionPoly();
			var poly3D = new CollisionPolygon3D();
			poly3D.Polygon = poly.Polygon;
			// Log("break", this, color: LogColors.GREEN);
			// foreach (var str in poly.Polygon)
			// {
			// 	Log(str.ToString(), this);
			// }
			poly3D.Depth = 10;
			poly3D.Position = new Vector3(operationArea2D.Position.X, operationArea2D.Position.Y, 0);
			var area3D = new Area3D();
			area3D.AddChild(poly3D);
			Array<Vector3> vertices = new Array<Vector3>();
			var polygon = poly3D.Polygon;

			foreach (var num in new [] {0,1,2,2,3,0})
			{
				vertices.Add(Vec23(polygon[num]));
			}

			var mesh = new MeshInstance3D();
			var arrayMesh = new ArrayMesh();
			Array arrays = [];
			arrays.Resize((int)Mesh.ArrayType.Max);
			arrays[(int)Mesh.ArrayType.Vertex] = vertices.ToArray();
			arrayMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
			mesh.Mesh = arrayMesh;

			var material = new StandardMaterial3D();
			material.AlbedoColor = operationArea2D.color;
			var meshTexture = new MeshTexture();
			meshTexture.Mesh = mesh.Mesh;
			material.AlbedoTexture = meshTexture;
			
			mesh.MaterialOverride = material;
			mesh.Position = Vector3.Zero;
			area3D.AddChild(mesh);
			
			area3DContainer.AddChild(area3D);
		}
	}

	private Vector3 Vec23(Vector2 vec2, float depth = 0)
	{
		return new Vector3(vec2.X, vec2.Y, depth);
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
	OperationPath2D.StartPoint startPoint = OperationPath2D.StartPoint.TopLeft)
{
	private readonly Vector2 _center = center;
	private StartPoint _startPoint = startPoint;
	private Vector2 _size = size;
	private const int AttemptThreshold = 50;
	private Array<OperationArea2D> _areas = new Array<OperationArea2D>();
	
	public Array<OperationArea2D> GetAreas() => _areas;

	public enum StartPoint
	{
		TopLeft,
		TopRight,
		BottomLeft,
		BottomRight
	}
	
	private Vector2 GetStartPoint(Vector2? border = null)
	{
		if (border == null) border = _size / 2;
		
		switch(startPoint)
		{
			case StartPoint.TopLeft:
				return center - border.Value;
			case StartPoint.TopRight:
				return center + new Vector2(border.Value.X, - border.Value.Y);
			case StartPoint.BottomLeft:
				return center + new Vector2(-border.Value.X, border.Value.Y);
			case StartPoint.BottomRight:
				return center + border.Value;
			default:
				return new(0, 0);
		}
	}
	
	// generates a curve that also happens to render if you treat it correctly. 
	public bool GenerateCurve()
	{
		foreach (var kid in owner.GetChildren())
		{
			owner.RemoveChild(kid);
			kid.QueueFree();
		}
		var startChildren = owner.GetChildren();
		// Log(GetStartPoint() + "", owner);
		
		var points = new List<Vector2> { (GetStartPoint() - _center) };
		
		Random random = new Random();
		int rBottom = (int) pointSpaceRange.X;
		int rRange = Math.Abs((int)pointSpaceRange.Y - (int)pointSpaceRange.X);
		var prevDir = new Vector2(0, 0);
		int attempts = 0;
		int i = 1;
		while (i < pointCount) 
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
					// Log("out of bounds", owner);
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
				area.SetCollisionPoly(collision);
				owner.AddChild(area);
				area.InputPickable = true;
				area.QueueRedraw();

				var rayOffset = Vector2.Zero;
				// Log("Ray section", owner);
				raycast:
				// Log("Ray offset: " + rayOffset, owner);
				
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
						owner.RemoveChild(area);
						area.QueueFree();
						owner.RemoveChild(ray);
						ray.QueueFree();
						// i--;
						continue;
					}
				}
				owner.RemoveChild(ray);
				ray.QueueFree();
				var rayShift = InvertVec2(dir) * lineWidth;
				if (rayOffset == Vector2.Zero)
				{
					rayOffset = rayShift;
					goto raycast;
				}
				if (rayOffset == rayShift)
				{
					rayOffset = -1 * rayShift;
					goto raycast;
				}

				// Utils.Log($"attempts: {attempts}", owner, color: "blue");
				points.Add(newPoint);
				// Log($"i: {i}", owner);
				// Log($"points: {points.Count}", owner);
				prevDir = dir;
				// owner.RemoveChild(ray);
				// ray.QueueFree();
				i++;
				attempts = 0;
				break;
			} while (true);
		}

		var endChildren = owner.GetChildren().Except(startChildren);
		foreach (Node child in endChildren)
		{
			if (child is Node2D)
			{
				((Node2D)child).Position += _center;
			}

			if (child is OperationArea2D)
			{
				_areas.Add((OperationArea2D)child);
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
