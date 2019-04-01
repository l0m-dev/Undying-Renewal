//=============================================================================
// DynamicZoneInfo.
//=============================================================================
class DynamicZoneInfo expands ZoneInfo;

#exec TEXTURE IMPORT NAME=DZoneInfo FILE=DZoneInfo.pcx GROUP=System Mips=Off Flags=2

var() enum EMethod
{
	METHOD_Above,
	METHOD_Within
} Method;

struct ZoneParams {
	var() 		vector 	ZoneGravity;
	var() 		vector	ZoneVelocity;
	var()		int		DamagePerSec;
	var() 		name	DamageType;
	var() localized string DamageString;
	var()		bool	bWaterZone;   // Zone is water-filled.
	var()		bool	bKillZone;    // Zone instantly kills those who enter.
	var()		bool	bPainZone;	 // Zone causes pain.
	var() 		vector	ViewFlash;
	var()		vector	ViewFog;
};

var() ZoneParams Method_True;
var() ZoneParams Method_False;
var() ZoneParams TriggeredParams;

var() name MoverTag;
var() name SatelliteTag;

var int MyZoneID;
var bool bTriggered, bWaterSounds;
var() savable bool bActive;
var savable bool bTrue, bUpdateActors, bFootTrue, bHeadTrue, bForceUpdate;
var() bool bTriggerable;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	MyZoneID = Level.GetZone(Location);
	bUpdateActors = true;
	bSavable=true;
	if (Method_True.bWaterZone || Method_False.bWaterZone)
		bWaterSounds = true;
}


// for the changable items, set them to the Actor's defaults.
function SetDefaultZoneProps()
{
	ZoneGravity = default.ZoneGravity;
	ZoneVelocity = default.ZoneVelocity;
	DamagePerSec = default.DamagePerSec;
	DamageType = default.DamageType;
	DamageString = default.DamageString;
	bWaterZone = default.bWaterZone;
	bKillZone = default.bKillZone;
	bPainZone = default.bPainZone;
	ViewFlash = default.ViewFlash;
	ViewFog = default.ViewFog;
}

// for the changable items, set them to ZoneParams stored values
function SetZone()
{
	if ( !bFootTrue )
	{
		//log("Setting bFootTrue Properties", 'Misc');
		bPainZone = Method_True.bPainZone;
		DamagePerSec = Method_True.DamagePerSec;
		DamageType = Method_True.DamageType;
		DamageString = Method_True.DamageString;
		bKillZone = Method_True.bKillZone;
	} else {
		bPainZone = Method_False.bPainZone;
		DamagePerSec = Method_False.DamagePerSec;
		DamageType = Method_False.DamageType;
		DamageString = Method_False.DamageString;
		bKillZone = Method_False.bKillZone;
		//log("NOT Setting bFootTrue Properties", 'Misc');
	}
	
	if ( !bHeadTrue )
	{
		//log("Setting bHeadTrue Properties", 'Misc');
		ViewFlash = Method_True.ViewFlash;
		ViewFog = Method_True.ViewFog;
		bWaterZone = Method_True.bWaterZone;
	} else {
		ViewFlash = Method_False.ViewFlash;
		ViewFog = Method_False.ViewFog;
		bWaterZone = Method_False.bWaterZone;
		//log("NOT Setting bHeadTrue Properties", 'Misc');
	}
	
	if ( !bHeadTrue )
	{
		//log("Setting bTrue Properties", 'Misc');
		ZoneGravity = Method_True.ZoneGravity;
		ZoneVelocity = Method_True.ZoneVelocity;

	} else {
		ZoneGravity = Method_False.ZoneGravity;
		ZoneVelocity = Method_False.ZoneVelocity;
		//log("NOT Setting bTrue Properties", 'Misc');
	}

}

function SetZoneProps(ZoneParams Z)
{
	bPainZone = Z.bPainZone;
	DamagePerSec = Z.DamagePerSec;
	DamageType = Z.DamageType;
	DamageString = Z.DamageString;
	ViewFlash = Z.ViewFlash;
	ViewFog = Z.ViewFog;
	ZoneGravity = Z.ZoneGravity;
	ZoneVelocity = Z.ZoneVelocity;
	bWaterZone = Z.bWaterZone;
	bKillZone = Z.bKillZone;
}

event ActorLeaving( actor Other )
{
	local actor A;

	if( Pawn(Other)!=None && Pawn(Other).bIsPlayer )
	{
		AeonsPlayer(Other).bWetFeet = false;
		if( --ZonePlayerCount==0 && ZonePlayerEvent!='' )
			foreach AllActors( class 'Actor', A, ZonePlayerEvent )
				A.UnTrigger( Self, Pawn(Other) );
	}
}


state() Dynamic_Zone
{
	
	simulated function Tick(float DeltaTime)
	{
		local Mover M, Mov;
		local Actor A;
		local AeonsPlayer P;
		local vector EyeHeight;
		local bool bWithin, bEntrySound, bExitSound;
		local int i;
		local ZoneSatellite ZS;
		
		if (bActive)
		{
			// Find our target Mover.
			ForEach AllActors(class 'Mover', M, MoverTag)
			{
				Mov = M;
				break;
			}
		
			ForEach ZoneActors(class 'AeonsPlayer',P)
			{
				// Player is in my zone?
				if (P.Region.Zone == self)
				{
					bForceUpdate = false;
					switch( Method )
					{
						case METHOD_Above:
							EyeHeight.z = P.eyeheight;
							if (Mov != none)
								// Head
								if ( (P.Location.z+EyeHeight.z) < M.Location.z)
								{
									if (!bHeadTrue)
									{
										bForceUpdate = true;
										bHeadTrue = true;
									}
								} else {
									if (bHeadTrue)
									{
										bForceUpdate = true;
										bHeadTrue = false;
									}
								}

								// Foot
								if ( (P.Location.z-P.CollisionHeight) < M.Location.z)
								{
									if ( !bFootTrue )
									{
										bForceUpdate = true;
										bFootTrue = true;
										P.bWetFeet = true;
										bEntrySound = true;
										//log("bFootTrue = TRUE", 'Misc');
									}
								} else {
									if ( bFootTrue )
									{
										bForceUpdate = true;
										bFootTrue = false;
										P.bWetFeet = false;
										bExitSound = true;
										//log("bFootTrue = FALSE", 'Misc');
									}
								}


								//Body
								if ( P.Location.z < M.Location.z)
								{
									if ( !bTrue )
									{
										bTrue = true;
										bUpdateActors = true;
									} else if ( bForceUpdate ) {
										bUpdateActors = true;
									}
								} else {
									if ( bTrue )
									{
										bTrue = false;
										bUpdateActors = true;
									} else if ( bForceUpdate ) {
										bUpdateActors = true;
									}
								}
								if (bForceUpdate)
									SetZone();
							break;

						case METHOD_Within:
							ForEach P.TouchingActors(class 'ZoneSatellite', ZS)
							{
								if (((ZS.Tag == SatelliteTag) && ZS.bActive) || ((ZS.DynamicZoneTag == SatelliteTag) && ZS.bActive))
									bWithin = true;
							}
	
							if ( bWithin )
							{
								SetZoneProps(Method_True);
								if (!bTrue)
								{
									bTrue = true;
									bUpdateActors = true;
									bEntrySound = true;
								}
							} else {
								SetZoneProps(Method_False);
								if (bTrue)
								{
									bTrue = false;
									bUpdateActors = true;
									bExitSound = true;
								}
							}
	
							break;
					}; // end switch
				}
			}

			if ( bUpdateActors )
			{
				//log("Updating Zone Actors .... ", 'Misc');
				// Update them
				ForEach ZoneActors(class 'Actor', A)
				{
					ActorEntered( A );
					

					if ( A.IsA('PlayerPawn') && bWaterSounds)
					{
						if (bEntrySound)
							A.PlaySound(EntrySound);
						if (bExitSound)
							A.PlaySound(ExitSound);
					}

					A.ZoneChange(self);
					if ( bPainZone && A.IsA('Pawn') )
					{	
						Pawn(A).PainTime = 1.0;
					} else if ( bWaterZone && A.IsA('Pawn') ) {
						Pawn(A).PainTime = Pawn(A).UnderWaterTime;
					}
				}
				bUpdateActors = false;
			}
		}
	}
	
	function Trigger(Actor Other, Pawn Instigator)
	{
		if ( bTriggerable )
			bActive = !bActive;
	}

	Begin:
}

// This zone gets triggred.
state() Triggered_Zone
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local Actor A;
		
		if ( bTriggered )
			SetDefaultZoneProps();
		else
			SetZoneProps( TriggeredParams );

		// flip
		bTriggered = !bTriggered;

		// Notify actors in the zone that I have changed some of my values.
		ForEach ZoneActors(class 'Actor', A)
		{
			if (A.Region.Zone == self)
			{
				ActorEntered( A );
				A.ZoneChange(self);
			}
		}
		
	}


	Begin:

}

defaultproperties
{
     bTriggerable=True
     EntrySound=Sound'CreatureSFX.SharedHuman.P_SlashIn01'
     ExitSound=Sound'CreatureSFX.SharedHuman.P_SplashOut01'
     bStatic=False
     bHidden=False
     bNoDelete=False
     InitialState=Triggered_Zone
     Texture=Texture'Aeons.System.DZoneInfo'
     DrawScale=0.5
}
