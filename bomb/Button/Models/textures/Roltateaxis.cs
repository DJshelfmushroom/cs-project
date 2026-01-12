using Godot;
using System;

public partial class Roltateaxis : Node3D
{
    public override void _Process(double delta)
    {
        base._Process(delta);
        GetNode("../../Bomb_instance").Call("GetBombRotation");
    }
}
