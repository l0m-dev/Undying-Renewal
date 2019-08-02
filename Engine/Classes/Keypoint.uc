//=============================================================================
// Keypoint, the base class of invisible actors which mark things.
//=============================================================================
class Keypoint extends Invisible
	abstract
	native;

// Sprite.
#exec Texture Import File=Textures\Keypoint.pcx Name=S_Keypoint Mips=On Flags=2

defaultproperties
{
     bStatic=True
     bHidden=True
     Texture=Texture'Engine.S_Keypoint'
     SoundVolume=0
     CollisionRadius=10
     CollisionHeight=10
}
