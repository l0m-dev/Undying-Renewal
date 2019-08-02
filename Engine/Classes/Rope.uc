//=============================================================================
// Rope.
//=============================================================================
class Rope expands Cloth
	native;

var(Cloth) bool AffectRoot;			// Rope is run from joint down to root as well as above.

defaultproperties
{
     StiffnessStretch=1000
     StiffnessFlex=0.2
     Drag=1
}
