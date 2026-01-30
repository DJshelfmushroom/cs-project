using Godot;

// Utility class to handle mesh instantiation/placement so the bomb class stays focused.
public static class InstanceUtils
{
    // Instantiate meshes for the given bomb node using the provided packed scene.
    public static void MakeInstances(Node3D parentNode, PackedScene instanceScene)
    {
        var plugLocs = parentNode.GetNodeOrNull<Node>("../PlugLocs");
        if (plugLocs == null)
            return;

        for (var i = 0; i < plugLocs.GetChildCount(); i++)
        {
            var loc = plugLocs.GetChildren()[i] as Node3D;
            if (loc == null) continue;

            // instantiate an instance from the scene
            var inst = instanceScene.Instantiate();
            if (!(inst is Node3D instanceNode))
                continue;

            parentNode.AddChild(instanceNode);
            // position at the PlugLocs child (keeps previous behavior)
            instanceNode.GlobalPosition = loc.GlobalPosition;

            var ray = instanceNode.GetNodeOrNull<RayCast3D>("RayCast3D");
            if (ray == null) continue;
            ray.Enabled = true;
            // set target position in local space relative to the ray
            ray.TargetPosition = ray.ToLocal(parentNode.GlobalPosition);
            ray.ForceRaycastUpdate();

            if (ray.IsColliding())
            {
                // Normal of the collision point
                var normal = ray.GetCollisionNormal().Normalized();
                var collisionPoint = ray.GetCollisionPoint();
                // Set the instance's position to the collision point (and rotate it to face outwards)
                instanceNode.LookAt(collisionPoint + normal, instanceNode.Transform.Basis.Z);
                instanceNode.GlobalPosition = collisionPoint;
            }
        }
    }
}
