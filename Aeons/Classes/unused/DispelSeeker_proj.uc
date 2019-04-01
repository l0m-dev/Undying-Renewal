//=============================================================================
// DispelSeeker_proj.
//=============================================================================
class DispelSeeker_proj expands SpellProjectile;

var ParticleFX pFX;
var() class<ParticleFX> ParticleFXClass;

function int Dispel(optional bool bCheck)
{
	if ( bCheck )
		return -1;
	else
		return 0;
}

function PreBeginPlay()
{
	if ( ParticleFXClass != none )
	{
		log ("Generating particle trail effect", 'Misc');
		pFX = spawn(ParticleFXClass,,,Location);
		pFX.setBase(self);
	}
}

function Destroyed()
{
	log (""$self.name$" is destroyed", 'Misc');
	if (pFX != none)
		pFX.bShuttingDown = true;
}

auto State Seeking
{
	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
		log(""$self.name$" Dispel Seeker Touch "$Other, 'Misc');
		if ( Other == Owner )
		{
			Owner.Dispel();
			Destroy();
		}
	}

	function Tick(float DeltaTime)
	{
		if (VSize(Owner.Location - Location) <= 32)
			ProcessTouch(Owner, Owner.Location);
		Velocity = Normal(Owner.Location - Location) * fMax((VSize(Owner.Velocity) * 2), Speed);
	}

	Begin:
	
}

defaultproperties
{
     ParticleFXClass=Class'Aeons.DispelTrailParticles'
     Speed=2000
     DrawType=DT_Sprite
}
