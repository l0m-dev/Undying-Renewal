//=============================================================================
// CombinedEffects.
//=============================================================================
class CombinedEffects expands Effects;

//#exec TEXTURE IMPORT FILE=CombinedEffect.pcx GROUP=System Mips=Off

struct SpawnedEffect
{
	var() name Tag;
	var() name Event;
	var() vector Offset;
	var() class<Actor> EffectClass;
	var() int OwnerID;
	var() bool bOwned;
};

var() Sound TriggeredSound;
var() bool bDeleteSelf;
var() bool bTriggerOnly;
var() SpawnedEffect EffectList[8];
var() int DamageThreshold;
var() bool bAcceptDamage;
var Actor ATemp[8];
var bool bStuffActive;
var() bool bSilent;

function GenerateStuff()
{
	local int i;
	local Actor A;

	// log("Combined Effect .. generating stuff", 'Misc');
	for (i=0; i<8; i++)
	{
		if ( EffectList[i].EffectClass != none )
		{
			A = spawn(EffectList[i].EffectClass,,,(Location + EffectList[i].Offset), Rotation);
			ATemp[i] = A;
			
			if (bSilent)
				A.AmbientSound = none;

			if ( EffectList[i].bOwned )
				A.SetOwner(ATemp[EffectList[i].OwnerID]);

			// Tag
			if ( !bAcceptDamage )
			{
				if (EffectList[i].Tag != 'none')
					A.Tag = EffectList[i].Tag;
				else
					A.Tag = Tag;
			} else {
				A.Tag = self.name;
			
			}
			// Event
			if (EffectList[i].Event != 'none')
				A.Event = EffectList[i].Event;
			else
				A.Event = Event;
		}
	}

	bStuffActive = true;
	
	if ( bDeleteSelf )
		Destroy();
}

function Trigger( Actor Other, Pawn EventInstigator )
{
	if (TriggeredSound != none)
		PlaySound(TriggeredSound);

	if ( !bStuffActive )
	{
		GenerateStuff();
	} else
		TurnStuffOff();
}
	
function PostBeginPlay()
{
	super.PostBeginPlay();

	// log("CombinedEfx PostBeginPlay", 'Misc');
	if ( !bTriggerOnly )
		GenerateStuff();
}

function ShutDown()
{
	local Actor A;
	
	ForEach AllActors (class 'Actor', A, self.name)
	{
		if ( A.IsA('ParticleFX') )
		{
			ParticleFX(A).Shutdown();
		} else {
			A.Destroy();
		}
	}
	Destroy();
}

function TurnStuffOff()
{
	local int i;
	for ( i=0; i<8; i++ )
	{
		if ( ATemp[i] != none)
		{
			if ( ATemp[i].IsA('ParticleFX') )
			{
				ParticleFX(ATemp[i]).Shutdown();
			} else {
				ATemp[i].Destroy();
			}
		}
	}
	Destroy();
}

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo);
/*
{
	// log("CombinedEffect TakeDamage()", 'Misc');
	if ( bAcceptDamage )
	{
		// log("Accepting Damage - Incoming DamageType is "$DInfo.DamageType, 'Misc');
		switch( DInfo.DamageType )
		{
			case 'SphereOfCold':
				if ( DInfo.Damage >= DamageThreshold )
				{
					ShutDown();
				}
				break;

			default:
				break;
		}
	}
}*/

defaultproperties
{
     DamageThreshold=1
     bAcceptDamage=True
     bHidden=True
     bDirectional=True
     DrawType=DT_Sprite
     Texture=Texture'Aeons.System.CombinedEffect'
     bCollideWhenPlacing=True
     CollisionRadius=20
     CollisionHeight=20
     bCollideActors=True
     bCollideWorld=True
     bProjTarget=True
}
