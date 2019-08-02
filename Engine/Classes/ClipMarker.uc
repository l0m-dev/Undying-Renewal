//U2Ed

//=============================================================================
// ClipMarker.
//
// These are markers for the brush clip mode.  You place 2 or 3 of these in
// the level and that defines your clipping plane.
//
// These should NOT be manually added to the level.  The editor adds and
// deletes them on it's own.
//
//=============================================================================
class ClipMarker extends Keypoint
	native;

#exec Texture Import File=Textures\S_ClipMarker.pcx Name=S_ClipMarker Mips=On Flags=2

defaultproperties
{
     bEdShouldSnap=True
     Style=STY_Translucent
     Texture=Texture'Engine.S_ClipMarker'
}
