//=============================================================================
// Cloth.
//=============================================================================
class Cloth expands Modifier
	native;

// Cloth params
var(Cloth) float	StiffnessStretch,		// Frequency of oscillation (1/s).
					StiffnessFlex,
					StiffnessShape;
var(Cloth) float	Damping;				// Fraction of critical damping (0..1).
var(Cloth) float	Drag;					// Wind/air resistance (1/s).
var(Cloth) float	Friction;				// Surface sliding resistance (1/s).
var(Cloth) float	GravityScale;			// Multiplier for gravity.
var(Cloth) vector	LocalWind;				// A "wind" which travels with actor (u/s).

var(Cloth) bool		CollideMesh;			// Enable collisions on mesh.
var(Cloth) bool		CollideWorld;			// Enable collisions on mesh.
var(Cloth) vector	FixDir;					// If non-zero, which side/edge of cloth
											// points to fix.
var(Cloth) float	Step;					// Step size to take, in radians (for debugging).

defaultproperties
{
     StiffnessStretch=100
     StiffnessFlex=0.5
     Damping=1
     Drag=5
     Friction=5
     GravityScale=1
     Step=2.5
}
