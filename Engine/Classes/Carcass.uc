//=============================================================================
// Carcass.
//=============================================================================
class Carcass extends Decoration
	native;

// Sprite.
//#exec Texture Import File=Textures\Corpse.pcx Name=S_Corpse Mips=On Flags=2

// Variables.
var bool bPlayerCarcass;
var() byte flies;
var() byte rats;
var() bool bReducedHeight;
var bool bDecorative;
var bool bSlidingCarcass;
var int CumulativeDamage;
var PlayerReplicationInfo PlayerOwner;

var Pawn Bugs;

	function CreateReplacement()
	{
		if (Bugs != None)
			Bugs.Destroy();
	}

	function Destroyed()
	{
		local Actor A;

		if (Bugs != None)
			Bugs.Destroy();
				
		Super.Destroyed();
	}

	function Initfor(actor Other)
	{
		//implemented in subclasses
	}
			
	function ChunkUp(int Damage)
	{
		destroy();
	}
	
	static simulated function bool AllowChunk(int N, name A)
	{
		return true;
	}

	function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
	{
		if ( !bDecorative )
		{
			bBobbing = false;
			SetPhysics(PHYS_Falling);
		}
		if ( (Physics == PHYS_None) && (Momentum.Z < 0) )
			Momentum.Z *= -1;
		Velocity += 3 * momentum/(Mass + 200);
		if ( DInfo.DamageType == 'shot' )
			DInfo.Damage *= 0.4;
		CumulativeDamage += DInfo.Damage;
		if ( (((DInfo.Damage > 30) || !IsAnimating()) && (CumulativeDamage > 0.8 * Mass)) || (DInfo.Damage > 0.4 * Mass) 
			|| ((Velocity.Z > 150) && !IsAnimating()) )
			ChunkUp(DInfo.Damage);
		if ( bDecorative )
			Velocity = vect(0,0,0);
	}

auto state Dying
{
	ignores TakeDamage;

Begin:
	Sleep(0.2);
	GotoState('Dead');
}
	
state Dead 
{
	function Timer()
	{
		local bool bSeen;
		local Pawn aPawn;
		local float dist;

		if ( Region.Zone.NumCarcasses <= Region.Zone.MaxCarcasses )
		{
			if ( !PlayerCanSeeMe() )
				Destroy();
			else
				SetTimer(2.0, false);	
		}
		else
			Destroy();
	}
	
	function AddFliesAndRats()
	{
	}

	function CheckZoneCarcasses()
	{
	}
	
	function BeginState()
	{
		if ( bDecorative )
			lifespan = 0.0;
		else
			SetTimer(18.0, false);
	}
			
Begin:
	FinishAnim();
	Sleep(5.0);
	CheckZoneCarcasses();
	Sleep(7.0);
	if ( !bDecorative && !bHidden && !Region.Zone.bWaterZone && !Region.Zone.bPainZone )
		AddFliesAndRats();	
}

defaultproperties
{
     bDecorative=True
     Buoyancy=105
     bStatic=False
     bStasis=False
     Physics=PHYS_Falling
     LifeSpan=180
     AnimSequence=Dead
     DrawType=DT_Mesh
     Texture=Texture'Engine.S_Corpse'
     CollisionRadius=18
     CollisionHeight=4
     bCollideActors=True
     bCollideWorld=True
     bProjTarget=True
     Mass=180
}
