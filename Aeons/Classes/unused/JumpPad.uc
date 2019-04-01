//=============================================================================
// JumpPad.
//=============================================================================
class JumpPad expands Info;

#exec TEXTURE IMPORT FILE=JumpPad.pcx GROUP=System Mips=Off Flags=2

var() float Force;

function Touch(Actor Other)
{
	if ( Other.IsA('PlayerPawn') )
	{
		PlayerPawn(Other).SetPhysics(PHYS_Falling);
		PlayerPawn(Other).Velocity = Vector(Rotation) * Force;
	}
}

defaultproperties
{
     Force=512
     bDirectional=True
     Texture=Texture'Aeons.System.JumpPad'
     CollisionRadius=64
     CollisionHeight=64
     bCollideActors=True
}
