using System.Dynamic;
using csproject.scripts.core;
using Godot;

namespace csproject.scripts.puzzles.OperationSub;

public partial class OperationArea3D(OperationArea2D.Section section) : Area3D
{
    private static short _intersections = 0;
    private Operation _operation;
    private static bool _strikeOut = false;

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
        Utils.SetCursor(Utils.CursorState.Hand);
        _intersections++;
        base._MouseEnter();
        if (_intersections == 1 && section != OperationArea2D.Section.First)
        {
            _strikeOut = true;
            _operation.Failure();
            return;
        }

        if (section == OperationArea2D.Section.First)
        {
            _strikeOut = false;
        }

        
    }

    public override void _MouseExit()
    {
        Utils.SetCursor(Utils.CursorState.Arrow);
        base._MouseExit();
        // Utils.Logger.Log($"intersections: {_intersections}, Section: {section}, Strikeout: {_strikeOut}", this);
        _intersections--;
        if (_strikeOut)
        {
            _operation.Failure();
            _strikeOut = false;
            return;
        }
        // Utils.Logger.Log("1", this);
        // Utils.Logger.Log($"intersections: {_intersections}, Section: {section}, Strikeout: {_strikeOut}", this);
        if (_intersections <= 0 && section != OperationArea2D.Section.First)
        {
            _operation.Failure();
            return;
        }
        // Utils.Logger.Log("2", this);
        // Utils.Logger.Log($"intersections: {_intersections}, Section: {section}, Strikeout: {_strikeOut}", this);
        if (section == OperationArea2D.Section.Last)
        {
            _operation.Success();
        }

       
        
    }
}