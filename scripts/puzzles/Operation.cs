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
// ReSharper disable InconsistentNaming

namespace csproject.scripts.puzzles; 

/*
 
 This script is a mess because I was learning  while writing it. I don't feel like rewriting it but surely that couldn't be too difficult.
 
 */

public partial class Operation : Node3D
{
	[ExportGroup("Puzzle Settings")] 
	[Export] public Vector2 Center = new (0, 0);
	[Export] public Vector2 Size = new (500,500);
	[Export] public OperationPath2D.StartPoint startPoint = OperationPath2D.StartPoint.Bottom_Left;
	[Export] public float Line_Width = 5f;
	[Export] public float Depth = 10f;

	[ExportSubgroup("Segment Colors")] 
	[Export] public Color First_Segment = Colors.YellowGreen;
	[Export] public Color Middle_Segment = Colors.Aquamarine;
	[Export] public Color Last_Segment = Colors.Red;

	[ExportSubgroup("Advanced")]
	[Export] public float Point_Spacing_Range_Min = 50;
	[Export] public float Point_Spacing_Range_Max = 100;
	[Export] public ushort Segment_Count = 20;
	[Export] public uint Attempt_Threshold = 50;
	[Export] public float Space_Buffer = 3f;
	
	[ExportSubgroup("Don't Change")]
	[Export]
	public int id { get; set; } = 14; // to reference in GDScript
	[Export]
	public bool completed { get; set; } = false;
	
	// private OperationPath2D _operation;
	public override void _Ready()
	{
		// Log(GetParent().ToString(),  this);
		GenerateLine();
	}
#if DEBUG
	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event.IsActionPressed("key_x") && GetParent() is Window)
		{
			Log("refresh",  this, color: LogColors.GREEN);
			GenerateLine();
		}
	}
#endif

	private void GenerateLine() 
	{
		OperationPath2D operation = new OperationPath2D(
			Center,
			Size, 
			Segment_Count,
			new (Point_Spacing_Range_Min, Point_Spacing_Range_Max),
			this,
			Line_Width,
			startPoint,
			Space_Buffer,
			(int)Attempt_Threshold);
		operation.colors = [First_Segment, Middle_Segment, Last_Segment];
		operation:
		foreach (Node child in GetChildren())
		{
			if (child is OperationArea2D || child.Name.Equals("Area3DContainer")) {
				RemoveChild(child);
				child.QueueFree();
			}
		}

		// try
		// {
		
		if (!operation.GenerateCurve())
		{
			// Log("uh oh (rerunning)", this, LogType.Error);
			goto operation;
		}
		// Log("Passed", this, color: LogColors.GREEN);
		var area3DContainer = new Node3D();
		area3DContainer.Name = "Area3DContainer";
		AddChild(area3DContainer);
		foreach (var operationArea2D in operation.GetAreas())
		{
			var poly = operationArea2D.GetCollisionPoly();
			var poly3D = new CollisionPolygon3D();
			var extPolyline = Geometry2D.OffsetPolyline(
				[operationArea2D.SegmentFrom, operationArea2D.SegmentTo],
				Line_Width,
				endType: Geometry2D.PolyEndType.Square);
			poly3D.Polygon = extPolyline.Count > 0 ? extPolyline[0] : poly.Polygon;
			//Log("break", this, color: LogColors.GREEN);
			//foreach (var str in poly.Polygon)
			//{
				//Log(str.ToString(), this);
			//}
			poly3D.Depth = Depth;
			poly3D.Position = new Vector3(operationArea2D.Position.X, operationArea2D.Position.Y, 0);
			var area3D = new OperationArea3D(operationArea2D.GetSection());
			area3D.AddChild(poly3D);
			Array<Vector3> vertices = new Array<Vector3>();
			var polygon = poly3D.Polygon;
	
			#region Area3DMesh

			float depthPos = poly3D.Depth;
			float depthNeg = 0; 
			// facing out
			foreach (var num in new [] {0,1,2,2,3,0})
			{
				vertices.Add(Vec23(polygon[num] + operation.GetCenter(), depthPos));
			}
			// back faces (sort of unnecessary)
			foreach (var num in new [] {0,1,2,2,3,0})
			{
				vertices.Add(Vec23(polygon[num] + operation.GetCenter(), depthNeg));
			}
			
			// long sides
			// top
			vertices.Add(Vec23(polygon[1] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[0] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[0] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[1] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[1] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[0] + operation.GetCenter(), depthNeg));
			// bottom
			vertices.Add(Vec23(polygon[3] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[2] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[2] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[3] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[3] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[2] + operation.GetCenter(), depthNeg));
			
			// small ends
			// left side
			vertices.Add(Vec23(polygon[1] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[2] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[2] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[1] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[1] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[2] + operation.GetCenter(), depthNeg));
			// right side
			vertices.Add(Vec23(polygon[0] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[3] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[3] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[0] + operation.GetCenter(), depthPos));
			vertices.Add(Vec23(polygon[0] + operation.GetCenter(), depthNeg));
			vertices.Add(Vec23(polygon[3] + operation.GetCenter(), depthNeg));
			
			var mesh = new MeshInstance3D();
			var arrayMesh = new ArrayMesh();
			Array arrays = [];
			arrays.Resize((int)Mesh.ArrayType.Max);
			arrays[(int)Mesh.ArrayType.Vertex] = vertices.ToArray();
			arrayMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
			mesh.Mesh = arrayMesh;
			mesh.SetPosition(mesh.Position + new Vector3(0, 0, depthPos));
			#endregion

			var material = new StandardMaterial3D();
			material.CullMode = BaseMaterial3D.CullModeEnum.Disabled;
			material.AlbedoColor = operationArea2D.color;
			material.RenderPriority = 1;
			if (operationArea2D.GetSection() == OperationArea2D.Section.Middle)
			{
				material.RenderPriority = 1;
			}

			material.ShadingMode = BaseMaterial3D.ShadingModeEnum.Unshaded;
			material.Transparency = BaseMaterial3D.TransparencyEnum.Alpha;
			var meshTexture = new MeshTexture();
			meshTexture.Mesh = mesh.Mesh;
			material.AlbedoTexture = meshTexture;
			
			mesh.MaterialOverride = material;
			mesh.Position = Vector3.Zero;
			area3D.AddChild(mesh);
			
			area3DContainer.AddChild(area3D);
		}

		foreach (var child in GetChildren())
		{
			if (child is Area2D)
			{
				RemoveChild(child);
				child.QueueFree();
			}
		}
	}

	private Vector3 Vec23(Vector2 vec2, float depth = 0)
	{
		return new Vector3(vec2.X, vec2.Y, depth);
	}

	public void Success()
	{
		//Log("Success", this, color: LogColors.GREEN);
		completed = true;
		
	}

	private Array<Color> SetColors(Color color)
	{
		var colors = new Array<Color>();
		foreach (var child in GetChild<Node3D>(1).GetChildren())
		{
			foreach (var kid in child.GetChildren())
			{
				if (kid is MeshInstance3D meshInstance)
				{
					var material = meshInstance.GetActiveMaterial(0) as StandardMaterial3D;
					material.AlbedoColor = color;
					meshInstance.MaterialOverride = material;
				}
			}
		}
		return null;
	}

	public void Failure()
	{
		//Log("Failure", this, color: LogColors.RED);
		Utils.GetBombNode(this).Call("Strike");
	}
}

public class OperationPath2D(
	Vector2 center,
	Vector2 size,
	int pointCount,
	Vector2 pointSpaceRange,
	Node owner,
	float lineWidth = 5,
	OperationPath2D.StartPoint startPoint = OperationPath2D.StartPoint.Top_Left,
	float minSpacing = 3,
	int attemptThreshold = 50
	)
{
	private Array<OperationArea2D> _areas = new Array<OperationArea2D>();
	public Color[] colors = [Colors.Green, Colors.Aqua, Colors.Red];
	public Array<OperationArea2D> GetAreas() => _areas;
	public Vector2 GetCenter() => center;
	
	public enum StartPoint
	{
		Top_Left,
		Top_Right,
		Bottom_Left,
		Bottom_Right
	}
	
	private Vector2 GetStartPoint(Vector2? border = null)
	{
		if (border == null) border = size / 2;
		
		switch(startPoint)
		{
			case StartPoint.Top_Left:
				return center - border.Value;
			case StartPoint.Top_Right:
				return center + new Vector2(border.Value.X, - border.Value.Y);
			case StartPoint.Bottom_Left:
				return center + new Vector2(-border.Value.X, border.Value.Y);
			case StartPoint.Bottom_Right:
				return center + border.Value;
			default:
				return new(0, 0);
		}
	}
	
	// generates a curve that also happens to render if you treat it correctly. 
	public bool GenerateCurve()
	{
		// foreach (var kid in owner.GetChildren())
		// {
		// 	owner.RemoveChild(kid);
		// 	kid.QueueFree();
		// }
		var startChildren = owner.GetChildren();
		// Log(GetStartPoint() + "", owner);
		
		var points = new List<Vector2> { (GetStartPoint() - center) };
		
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
				if (attempts > attemptThreshold)
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
				
				if (newPoint.X > size.X / 2 || newPoint.X < 0 - size.X / 2 ||
					newPoint.Y >  size.Y / 2 || newPoint.Y < 0 - size.Y / 2)
				{
					// Log("out of bounds", owner);
					continue;
				}
				
				var polyline = Geometry2D.OffsetPolyline([points[i - 1], newPoint], lineWidth, endType: Geometry2D.PolyEndType.Joined);
				if (polyline.Count == 0) continue; 
				var collision = new CollisionPolygon2D();
				collision.Polygon = polyline.ToArray().First();
				OperationArea2D.Section lineSection;
				var color = colors[1];
				if (i == 1) 
				{lineSection = OperationArea2D.Section.First;
					color = colors[0];
				}
				else if (i == pointCount - 1) 
				{lineSection = OperationArea2D.Section.Last;
					color = colors[2];
				}
				else lineSection = OperationArea2D.Section.Middle;
				
				var area = new OperationArea2D(lineSection);
				area.color = color;
				area.SegmentFrom = points[i - 1];
				area.SegmentTo = newPoint;
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
				ray.TargetPosition = newPoint - points[i - 1] + rayOffset + (minSpacing * dir);
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
				var rayShift = InvertVec2(dir) * (lineWidth + minSpacing);
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
				((Node2D)child).Position += center;
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
