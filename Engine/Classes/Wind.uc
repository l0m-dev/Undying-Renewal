//=============================================================================
// Wind.
//=============================================================================
class Wind expands Invisible
	native;

/* Force-Recompile */

// Wind parameters are very similar to light parameters.
var(Wind) float	WindSpeed;				// Units per second; can be negative.
var(Wind) byte	WindRadius,				// World rad = WindRadius�
				WindRadiusInner,		// As with lights, fraction of max effect
				WindFluctuation,		// Fractional amount of random change
				WindFlucPeriod;			// Speed of change, arbitrary scale
var(Wind) ELightSource
				WindSource;				// Directionality.
var(Wind) bool	bPermeating;			// Goes through walls.


var transient vector 
	Fluc,								// Current vector fluctuation.
	FlucVel;							// Fluctuation velocity.

// Get the wind velocity at a location.
native(425) final function vector GetWind( vector Loc );

defaultproperties
{
     WindSpeed=256
     WindRadius=32
     WindFlucPeriod=32
     WindSource=LD_Plane
     bHidden=True
     bDirectional=True
     Texture=Texture'Engine.S_Flag'
     bNoDelete=True
}
