using System;
using Godot;
using csproject.scripts.core;
using static Godot.RenderingServer;
using static Godot.Viewport;

namespace csproject.scripts.menus.settings;
// ReSharper disable InconsistentNaming

public enum FeatureEnum
{
	AntiAliasing3D,
	ScreenSpaceAA,
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

	enum AntiAliasing3D : ushort
	{
		Disabled,
		MSAA_2X,
		MSAA_4X,
		MSAA_8X,
		TAA
	}

	protected override void SetupFeatures()
	{
		// Log($"Dict: {Features}, Length: {Features.Count}", Utils.Logger.LogType.Warning);
		Log($"type of AntiAliasing3D: {typeof(AntiAliasing3D).FullName}");
		Features.Add(FeatureEnum.AntiAliasing3D, new Feature(FeatureEnum.AntiAliasing3D, 
			(ushort)AntiAliasing3D.MSAA_4X, SetAntiAliasing3D,  typeof(AntiAliasing3D)));
		Features.Add(FeatureEnum.ScreenSpaceAA, new Feature(FeatureEnum.ScreenSpaceAA,
			(long) ViewportScreenSpaceAA.Fxaa, SetScreenSpaceAA, typeof(ViewportScreenSpaceAA)));
		Features.Add(FeatureEnum.AnisotropicFiltering, new Feature(FeatureEnum.AnisotropicFiltering, 
			(long) AnisotropicFiltering.Disabled, SetAnisotropicFiltering));
		Features.Add(FeatureEnum.Back, new Feature(FeatureEnum.Back, () => { SceneManager.ReturnToScene(this);}));
		Features.Add(FeatureEnum.Apply, new Feature(FeatureEnum.Apply, WriteSettings ));

		// Log($"Dict: {Features}, Length: {Features.Count}", Utils.Logger.LogType.Warning);
		// GD.Print($"Dict: {Features}, Length: {Features.Count}");
	}

	private void SetAntiAliasing3D()
	{
		// SceneTree sceneTree = Utils.GetSceneTree();
		Node loadedNode = Utils.GetNodeFromStatic();
		if (loadedNode != null)
		{
			// RenderingServer.ViewportSetMsaa3D(loadedNode.GetViewport().GetViewportRid(), RenderingServer.ViewportMsaa.Disabled);
			loadedNode.GetViewport().Msaa3D = (Msaa)Features[FeatureEnum.AntiAliasing3D].GetValue().As<long>();
			// RenderingServer.ViewportScreenSpaceAA
		}
	}

	private void SetScreenSpaceAA()
	{
		Node loadedNode = Utils.GetNodeFromStatic();
		if (loadedNode != null)
		{
			ViewportSetScreenSpaceAA(loadedNode.GetViewport().GetViewportRid(),
				(ViewportScreenSpaceAA)Features[FeatureEnum.ScreenSpaceAA].GetValue().As<long>());
		}
	}

	private void SetAnisotropicFiltering()
	{
		Node loadedNode = Utils.GetNodeFromStatic();
		if (loadedNode != null)
		{
			loadedNode.GetViewport().AnisotropicFilteringLevel = AnisotropicFiltering.Anisotropy2X;
		}
	}
}
