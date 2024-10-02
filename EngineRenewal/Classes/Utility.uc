//=============================================================================
// Utility.
//=============================================================================
class Utility expands Object
	noexport
	native;

native static final function texture LoadBMPFromFile(string Filename);
native static final function DestroyTexture(texture Texture); // calls: delete Texture
native static final function Screenshot(PlayerPawn Player, string Filename, optional bool bHideHud, optional bool bHideConsole);
native static final function string GetSavePath();
native static final function ComputeRenderSize(Canvas Canvas);

defaultproperties
{
     
}