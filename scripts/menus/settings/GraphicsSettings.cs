using System;
using Godot;
using csproject.scripts.core;
using static Godot.RenderingServer;
using static Godot.Viewport;

namespace csproject.scripts.menus.settings;
// ReSharper disable InconsistentNaming

public enum FeatureEnum
{
	AntiAliasing,
	ScreenSpaceAA,
	TAA,
	AnisotropicFiltering,
	Back,
	Apply
}

public partial class GraphicsSettings : Base.SettingsBase<FeatureEnum>
{
	public override FeatureEnum featureEnum => featureEnum;
	
	[Export] public Godot.Collections.Dictionary<NodePath, FeatureEnum> FeatureNode;

	public override void _Ready()
	{
		FeatureNodes = FeatureNode;
		base._Ready();
	}

	enum AntiAliasing : ushort
	{
		Disabled,
		// ReSharper disable twice UnusedMember.Local
		MSAA_2X,
		MSAA_4X,
		MSAA_8X,
		// TAA
	}

	protected override void SetupFeatures()
	{
		// Log($"Dict: {Features}, Length: {Features.Count}", Utils.Logger.LogType.Warning);
		// Log($"type of AntiAliasing3D: {typeof(AntiAliasing).FullName}");
		Features.Add(FeatureEnum.AntiAliasing, new Feature(FeatureEnum.AntiAliasing, 
			(ushort)AntiAliasing.Disabled, SetAntiAliasing3D,  typeof(AntiAliasing)));
		Features.Add(FeatureEnum.ScreenSpaceAA, new Feature(FeatureEnum.ScreenSpaceAA,
			(ushort) ViewportScreenSpaceAA.Fxaa, SetScreenSpaceAA, typeof(ViewportScreenSpaceAA)));
		Features.Add(FeatureEnum.AnisotropicFiltering, new Feature(FeatureEnum.AnisotropicFiltering, 
			(ushort) AnisotropicFiltering.Disabled, SetAnisotropicFiltering, typeof(AnisotropicFiltering)));
		Features.Add(FeatureEnum.TAA, new Feature(FeatureEnum.TAA, false, (value) =>
		{
			Utils.GetNodeFromStatic().GetViewport().SetUseTaa(value.AsBool());
		}));
		Features.Add(FeatureEnum.Back, new Feature(FeatureEnum.Back, (ignored) => { SceneManager.ReturnToScene(this);}));
		Features.Add(FeatureEnum.Apply, new Feature(FeatureEnum.Apply, WriteSettings ));

		// Log($"Dict: {Features}, Length: {Features.Count}", Utils.Logger.LogType.Warning);
		// GD.Print($"Dict: {Features}, Length: {Features.Count}");
	}

	private void SetAntiAliasing3D(Variant value)
	{
		// SceneTree sceneTree = Utils.GetSceneTree();
		Log($"AA Value: {value}");
		Node loadedNode = Utils.GetNodeFromStatic();
		if (loadedNode != null)
		{
			// RenderingServer.ViewportSetMsaa3D(loadedNode.GetViewport().GetViewportRid(), RenderingServer.ViewportMsaa.Disabled);
			loadedNode.GetViewport().Msaa3D = (Msaa)value.As<long>();
			loadedNode.GetViewport().Msaa2D = (Msaa)value.As<long>();
			// RenderingServer.ViewportScreenSpaceAA
		}
	}

	private void SetScreenSpaceAA(Variant value)
	{
		Node loadedNode = Utils.GetNodeFromStatic();
		if (loadedNode != null)
		{
			ViewportSetScreenSpaceAA(loadedNode.GetViewport().GetViewportRid(),
				(ViewportScreenSpaceAA)value.As<long>());
		}
	}

	private void SetAnisotropicFiltering(Variant value)
	{
		Node loadedNode = Utils.GetNodeFromStatic();
		if (loadedNode != null)
		{
			loadedNode.GetViewport().AnisotropicFilteringLevel = (AnisotropicFiltering)  value.As<int>();
		}
	}
}
