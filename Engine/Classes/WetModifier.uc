//=============================================================================
// WetModifier.
//=============================================================================
class WetModifier expands PlayerModifier;

var float ScaleDownTimer;
var float HoldTimer;
var color White, Black, Gray;
var float DeInc;

function PreBeginPlay()
{	
	super.PreBeginPlay();

	Gray.R = 100;
	Gray.g = 100;
	Gray.b = 100;
	Gray.a = 100;
	
	White.R = 255;
	White.g = 255;
	White.b = 255;
	White.a = 255;

	ScaleDownTimer = 5;
	HoldTimer = 5;
}

function Activate()
{
	gotoState('');
	if (Owner != none)
	{
		Pawn(Owner).Lighting[1].TextureMask = -1;
		Pawn(Owner).Lighting[1].Diffuse = Gray;
		Pawn(Owner).Lighting[1].SpecularHilite = White;
		Pawn(Owner).Lighting[1].SpecularWidth = 10;
	}
}

/* Lighting Properties
color	Constant;			// Constant (self-illumination) color.
color	Diffuse;			// Omni-directional reflectance (modulates texture).
color	SpecularShade;		// Directional reflectance, shading texture.
color	SpecularHilite;		// Directional reflectance, highlight texture.
byte	SpecularWidth;		// Sharpness: 0 = perfectly sharp, max = perfectly diffuse.
int   	TextureMask;		// Bitmask of textures this material applies to. -1 = all.
*/

function Deactivate()
{
	AttachDrips();
	gotoState('ShuttingDown');
}

function AttachDrips()
{

}

state ShuttingDown
{
	function TurnOff()
	{
		local Actor A;
		
		bActive = false;
		//ForEach AllActors(class 'Actor', A)
		//	if ( A.Owner == Pawn(Owner) )
		//		if ( A.IsA('ParticleFX') )
		//			ParticleFX(A).Destroy();

		Pawn(Owner).Lighting[1].TextureMask = 0;
		Pawn(Owner).Lighting[1].Diffuse = White;
		Pawn(Owner).Lighting[1].SpecularHilite = Black;
		Pawn(Owner).Lighting[1].SpecularWidth = 0;
	}
	
	function Drip()
	{
		
	
	}

	function Tick(float DeltaTime)
	{
		local Actor A;
		
		ForEach AllActors(class 'Actor', A)
			if ( A.Owner == Pawn(Owner) )
				if ( A.IsA('ParticleFX') )
					ParticleFX(A).Strength = FClamp(ParticleFX(A).Strength + 0.02, 0, 1);

		if (Pawn(Owner).Lighting[1].Diffuse.R < 255)
			Pawn(Owner).Lighting[1].Diffuse.R += 1;

		if (Pawn(Owner).Lighting[1].Diffuse.G < 255)
			Pawn(Owner).Lighting[1].Diffuse.G += 1;

		if (Pawn(Owner).Lighting[1].Diffuse.B < 255)
			Pawn(Owner).Lighting[1].Diffuse.B += 1;

		//R
		if (Pawn(Owner).Lighting[1].SpecularHilite.R >= 1)
			Pawn(Owner).Lighting[1].SpecularHilite.R -= 1;
		//G
		if (Pawn(Owner).Lighting[1].SpecularHilite.G >= 1)
			Pawn(Owner).Lighting[1].SpecularHilite.G -= 1;
		//B
		if (Pawn(Owner).Lighting[1].SpecularHilite.B >= 1)
			Pawn(Owner).Lighting[1].SpecularHilite.B -= 1;
	}

	function Timer()
	{
		if (FRand() > 0.50)
			Drip();
	}
	
	function BeginState()
	{
		local int NumJoints, i;
		local name JointName;
		local Actor A;
		local place P;
		
		if ( (Owner != none) && (Pawn(Owner).WaterParticles != none) )
		{
			NumJoints = Owner.NumJoints();
			if ( NumJoints > 0 )
			{
				bActive = true;
				for (i=0; i<NumJoints; i++)
				{
					JointName = Owner.JointName(i);
					P = Owner.JointPlace(JointName);
					// Only attach a drip on joints that are at or below the location of the owner.
					if ( P.pos.z <= (Owner.Location.z) )
					{
						A = Spawn(Pawn(Owner).WaterParticles, Owner,, P.pos);
						A.SetBase(Owner,JointName, 'root');
						A.LifeSpan = 1.0;
					}
				}
			}
		}

		disable('Tick');
	}

	function EndState()
	{
		TurnOff();
	}

	Begin:
		setTimer(0.25, true);
		//sleep(HoldTimer);
		enable('Tick');
		sleep(ScaleDownTimer);
		gotoState('');
}


state Idle
{
	Begin:
}

defaultproperties
{
}
