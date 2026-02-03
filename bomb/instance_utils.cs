using Godot;

public static class InstanceUtils
{
    public static void MakeInstances(Node3D parentNode, PackedScene instanceScene)
    {
        var instanceLocs = parentNode.GetNodeOrNull<Node>("../Instances");
        if (instanceLocs == null)
            return;

        for (var i = 0; i < instanceLocs.GetChildCount(); i++)
        {
            var loc = instanceLocs.GetChildren()[i] as Node3D;
            if (loc == null) continue;

            var inst = instanceScene.Instantiate();
            if (!(inst is Node3D instanceNode))
                continue;

            parentNode.AddChild(instanceNode);
            instanceNode.GlobalPosition = loc.GlobalPosition;

            var ray = instanceNode.GetNodeOrNull<RayCast3D>("RayCast3D");
            if (ray == null) continue;
            ray.Enabled = true;
            ray.TargetPosition = ray.ToLocal(parentNode.GlobalPosition);
            ray.ForceRaycastUpdate();

            if (ray.IsColliding())
            {
                var normal = ray.GetCollisionNormal().Normalized();
                var collisionPoint = ray.GetCollisionPoint();
                instanceNode.LookAt(collisionPoint + normal, instanceNode.Transform.Basis.Z);
                instanceNode.GlobalPosition = collisionPoint;
            }
        }
    }
}
