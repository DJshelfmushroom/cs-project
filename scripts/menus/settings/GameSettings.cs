using csproject.scripts.core;
using Godot;
using csproject.scripts.menus.settings.Base;

namespace csproject.scripts.menus.settings;

public enum FeaturesEnum
{
	Background,
	PuzzleCompleteAnimation,
	HardModeOnly,
	ExpertModeOperation,
	ExpertModeOperationInGame,
	SpecialOperationCursor,
	ResetData,
	ResetSettings,
	// Debug,
	Back
}

public partial class GameSettings : SettingsBase<FeaturesEnum>
{
	public override FeaturesEnum featureEnum { get; }
	
	[Export] public Godot.Collections.Dictionary<NodePath, FeaturesEnum> FeatureNode;
	
	public override void _Ready()
	{
		FeatureNodes = FeatureNode;
		base._Ready();
	}

	
	protected override void SetupFeatures()
	{
	}

	private void SetBackground(Variant background)
	{
	}
	private void SetPuzzleCompleteAnimation(Variant puzzleCompleteAnimation)
	{
	}

	private void SetHardModeOnly(Variant hardModeOnly)
	{
	}

	private void SetExpertModeOperation(Variant expertModeOperation)
	{
	}

	private void SetExpertModeOperationInGame(Variant expertModeOperation)
	{
	}

	private void SetSpecialOperationCursor(Variant specialOperationCursor)
	{
	}

	private void SetResetData(Variant resetData)
	{
		Script saveManager = Utils.GetSaveManager();
		saveManager.Call("delete_save_data");
	}

	private void ResetSettings(Variant ignored)
	{
		Script mainMenu = GD.Load<Script>("res://scripts/menus/main_menu.gd");
		mainMenu.Load
	}

	private void Back(Variant ignored)
	{
		SceneManager.ReturnToScene(this);
	}

}
