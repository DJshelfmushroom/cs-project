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
        base._MouseEnter();
        Utils.SetCursor(Utils.CursorState.Hand);
        _intersections++;
        if (!Input.IsActionPressed("ui_mouse_left_button")) return;
        
        if (_intersections == 1 && section != OperationArea2D.Section.First)
        {
            _strikeOut = true;
            // _operation.Failure();
            return;
        }

        if (section == OperationArea2D.Section.First)
        {
            _strikeOut = false;
        }

        
    }

    public override void _MouseExit()
    {
        base._MouseExit();
        if (!Input.IsActionPressed("ui_mouse_left_button")) return;
        Utils.SetCursor(Utils.CursorState.Arrow);
        // Utils.Logger.Log($"intersections: {_intersections}, Section: {section}, Strikeout: {_strikeOut}", this);
        _intersections--;
        if (_strikeOut)
        {
            _operation.Failure();
            _strikeOut = false;
        }
        else
        {
            if (section == OperationArea2D.Section.Last)
            {
                _operation.Success();
            }
            else
            {
                if (_intersections <= 0 && section != OperationArea2D.Section.First)
                {
                    _operation.Failure();
                }
            }
        }

    }
}