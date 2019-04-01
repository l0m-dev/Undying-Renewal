//=============================================================================
// LightningTracer_proj.
//=============================================================================
class LightningTracer_proj expands SpellProjectile;

// used to trace positions for the lightning strike

var vector seekLocation;
var vector lastPos;
var vector origin;

auto state Flying
{
	function Tick( float DeltaTime )
	{
		local vector rd, cd, sd, fd, fl;
		local LightningPoint lp;
		local rotator	rot;
		
		rd = VRand() * 0.5;						// random direction
		cd = Normal(Vector(Rotation)) * 0.5;	// current direction
		sd = Normal(seekLocation - location);	// seeking direction
		fd = Normal(rd+cd+sd);					// final direction
		
		Velocity = fd * speed;
		if ( lastPos != origin ) {
			fl = (location + LastPos) * 0.5;
			rot = Rotator(location-lastPos);
			spawn(class'LightningPoint',,,fl, rot);
		}
				
		lastPos = location;
	}

	Begin:
		Velocity = Vector(rotation) * speed;
}

defaultproperties
{
     Speed=5000
     MaxSpeed=20000
}
