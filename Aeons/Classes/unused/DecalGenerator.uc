//=============================================================================
// DecalGenerator.
//=============================================================================
class DecalGenerator expands Generator;

#exec TEXTURE IMPORT NAME=DecalGen FILE=DecalGen.pcx GROUP=System Mips=On

var Decal D;
var() int 		SpewCount;
var() float 	SpewDist;
var() class<AeonsDecal> DecalClass;
var() name 		TargetTag;
var() sound 	SoundEffect;
var() bool		bAutoDestroy;
var() class<Effects> Effect;
var() bool bDecalScryeOnly;
var() float DecalLifeSpan;

var int i, HitJoint;
var vector HitLocation, HitNormal, End, SpewVector;

function GetSpewVector(out vector v)
{
	local Actor A;
	
	if (targetTag == 'none')
	{
		v = Vector(Rotation);
	} else {
		forEach AllActors(class 'Actor', A, TargetTag)
		{
			v = A.Location - Location;
			break;
		}
	}
}

auto state() StartupPlace
{
	function PlaceDecal()
	{
		if (DecalClass != none)
		{
			EnableLog('Misc');
			log("PlacingDecal ........ ", 'Misc');
			GetSpewVector(SpewVector);
			Trace(HitLocation, HitNormal, HitJoint, (Location + SpewVector * SpewDist), Location, false);
			D = spawn(DecalClass,,,HitLocation, rotator(HitNormal));
			D.bScryeOnly = bDecalScryeOnly;
			D.DecalLifetime = DecalLifeSpan;

			if (bAutoDestroy)
				Destroy();
		}
	}

	Begin:
		PlaceDecal();
}

state() TriggerPlace
{
	function PostBeginPlay();
	
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (DecalClass != none)
		{
			GetSpewVector(SpewVector);
			Trace(HitLocation, HitNormal, HitJoint, (Location + SpewVector * SpewDist), Location, false);
			D = spawn(DecalClass,,,HitLocation, rotator(HitNormal));
			D.bScryeOnly = bDecalScryeOnly;
			D.DecalLifetime = DecalLifeSpan;
			if (SoundEffect != none)
				PlaySound(SoundEffect);

			if (bAutoDestroy)
				Destroy();
			
			if (Effect != none)
				spawn(Effect,,,HitLocation, rotator(HitNormal));

		}
	}

	Begin:

}

state() TriggerSpew
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (DecalClass != none)
		{
			for (i=0; i<SpewCount; i++)
			{
				end = Location + (VRand() * SpewDist);
				Trace(HitLocation, HitNormal, HitJoint, End, Location, false);
				D = spawn(DecalClass,,,HitLocation, rotator(HitNormal));
				D.bScryeOnly = bDecalScryeOnly;
				D.DecalLifetime = DecalLifeSpan;
				
				if (SoundEffect != none)
					PlaySound(SoundEffect);

				if (bAutoDestroy)
					Destroy();

				if (Effect != none)
					spawn(Effect,,,HitLocation, rotator(HitNormal));

			}
		}
	}

	Begin:

}

defaultproperties
{
     SpewDist=256
     InitialState=StartupPlace
     Texture=Texture'Aeons.System.DecalGen'
}
