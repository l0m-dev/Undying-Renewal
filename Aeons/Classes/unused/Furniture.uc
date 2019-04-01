//=============================================================================
// Furniture.
//=============================================================================
class Furniture expands Decoration
	abstract;

defaultproperties
{
     Physics=PHYS_Falling
     bCollideActors=True
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
