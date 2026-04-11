using System.Dynamic;
using Godot;

namespace csproject.scripts.puzzles.OperationSub;

public partial class OperationArea3D(OperationArea2D.Section section) : Area3D
{
    private static ushort _intersections = 0;
    private Operation _operation;

    public override void _Ready()
    {
        base._Ready();
        Node parent = this;
        do
        {
            parent = parent.GetParent();
        } while (!(parent is Operation || parent is Window));
        _operation = (Operation)parent;
        if (_operation == null)
        {
            QueueFree();
        }
    }

    public override void _MouseEnter()
    {
        base._MouseEnter();
        if (_intersections == 0 && section != OperationArea2D.Section.First)
        {
            _operation.Failure();
            return;
        }
        _intersections++;
    }

    public override void _MouseExit()
    {
        base._MouseExit();
        _intersections--;
        if (section == OperationArea2D.Section.Last)
        {
            _operation.Success();
            return;
        }

        if (_intersections <= 0)
        {
            _operation.Failure();
        }
        
    }
}