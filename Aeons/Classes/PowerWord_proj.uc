//=============================================================================
// PowerWord_proj.
//=============================================================================
class PowerWord_proj expands SpellProjectile;

//#exec MESH IMPORT MESH=PowerWord_proj_m SKELFILE=PowerWord_proj_m.ngf

//#exec Texture Import File=PwrWord.bmp Group=Spells Mips=Off

// Internal Vars
var PowerWord 			ParentSpell;

var Pawn 				Targets[8];			// Active target list
var	ScriptedFX 			Shafts[8];			// particle shafts
var Siren_particles 	Sirens[8];			// number of active "Powder of the Siren" particle systems are active
var int 				NumKnots, SndID;
var vector 				Deltas[32];
var float 				DamageTimer, TotalTime;
var bool bHaveATarget;

var() sound SuckingSound;

function PreBeginPlay()
{
	switch ( CastingLevel )
	{
		case 0:
			DamageTimer = 1.0 / 20;
			break;

		case 1:
			DamageTimer = 1.0 / 30;
			break;

		case 2:
			DamageTimer = 1.0 / 40;
			break;

		case 3:
			DamageTimer = 1.0 / 50;
			break;

		case 4:
			DamageTimer = 1.0 / 60;
			break;

		case 5:
			DamageTimer = 1.0 / 70;
			break;
	};
	
}
	
simulated function PostBeginPlay()
{
	local Actor A;
	Super.PostBeginPlay();
	spawn(class 'DarkGlowScriptedFX',,,Location);
	A = spawn(class 'PowerWOrd_particles',self,,Location);
	A.SetBase(self);
	NumKnots = 32;
	// DrawScale = 2;
}

simulated function Destroyed()
{
	local int i;
	
	for (i=0; i<8; i++)
	{
		Targets[i] = none;
		if (Shafts[i] != none)
			Shafts[i].Destroy();
	}

	for (i=0; i<8; i++)
	{
		ParentSpell.Targets[i] = Targets[i];
		ParentSpell.Shafts[i]  = Shafts[i];
	}

	StopSound(SndID); //AmbientSound = none;
	ParentSpell.activeWord = false;
	ParentSpell.Finish();
}

// Hovering, damaging pawns
auto state Hover
{
	function Tick (float DeltaTime)
	{
		local vector X, Y, Z, EyeOffset;
		local int i;

		EyeOffset.Z = PlayerPawn(Owner).EyeHeight;

		if ( PlayerPawn(Owner).bFireAttSpell == 0 )
		{
			Destroy();
		} else {
			GetAxes(PlayerPawn(Owner).ViewRotation, X, Y, Z);
			setLocation(Owner.Location + EyeOffset + X*22 + Z*-10);
			FindTargets();
			ApplyDamage(DeltaTime);
			
			if ( bHaveATarget )
			{
				if ( SndID == 0 )
					SndID = PlaySound(SuckingSound);				
			} else {
				if ( SndID != 0 )
				{
					StopSound(SndID);
					SndID = 0;
				}
			}
		}

		for (i=0; i<8; i++)
		{
			ParentSpell.Targets[i] = Targets[i];
			ParentSpell.Shafts[i]  = Shafts[i];
		}

	}

	function ApplyDamage(float DeltaTime)
	{
		local int i;
		local int hp;
		local Pawn PawnOwner;
		
		PawnOwner = Pawn(Owner);

		TotalTime += DeltaTime;
		hp = TotalTime / DamageTimer;
		TotalTime -= (DamageTimer * hp);
				
		if ( hp > 0 )
		{
			for (i=0; i<8; i++)
				if ( Targets[i] != none )
				{
					if ( PlayerPawn(Owner).Weapon.IsA('Scythe') )
					{
						if (Targets[i].AcceptDamage(GetDamageInfo()))
						{
							Targets[i].TakeDamage(PawnOwner, Targets[i].Location, vect(0,0,0),getDamageInfo());
							// if ( PawnOwner.health < PawnOwner.default.health)
							PawnOwner.health = FClamp(PawnOwner.health + 0.25, 0, 200);
							Scythe(PawnOwner.Weapon).Drink();
						}
					} else {
						if (Targets[i].AcceptDamage(GetDamageInfo()))
							Targets[i].TakeDamage(PawnOwner, Targets[i].Location, vect(0,0,0),getDamageInfo());
					}
				}
		}
	}

	function UpdateTargets()
	{
		local int i;
		
		for (i=0; i<8; i++)
		{
			if (Targets[i] != none)
			{
				if ( (Targets[i].Health > 0) && Targets[i].bCollideActors )
				{
					if (Shafts[i] != none)
						UpdateShaft( Shafts[i], Location, Targets[i].Location );
					else
						Shafts[i] = Strike(Location, Targets[i].Location);
				} else {
					Targets[i] = none;
				}
			}
		}
	}

	function ScriptedFX Strike(vector Start, vector End)
	{
		local int i;
		local vector loc;
		local float scalar, len;
		local ScriptedFX sFX;

		// zero the deltas
		for (i=0; i<32; i++)
			deltas[i] = vect(0,0,0);

		sFX = spawn(class 'PWScriptedFX',self,,Start);
		sFX.SetLocation(start);

		len = VSize(end-start) / float(numKnots);

		for (i=0; i<24; i++)
		{
			deltas[i] = VRand() * 8;
			Loc = (start + Normal(end-start) * (len * i)) + deltas[i];
			sFX.AddParticle(i, Loc);
		}
		return sFX;
	}

	// Update the shaft points
	function UpdateShaft(ScriptedFX Shaft, vector Start, vector End)
	{
		local int i, HitJoint, Flags, hp, TotalAmplitude;
		local float len;
		local vector loc, HitLocation, HitNormal, X, Y, Z, LastPoint, ld, td, LastY, LastZ;
		local Texture HitTexture;
		local DamageInfo Di;

		Shaft.SetLocation(Start);

		len = VSize(End - Start) / float(numKnots);

		LastPoint = Start;

		Shaft.GetParticleParams(0,Shaft.Params);
		Shaft.Params.Position = LastPoint;
		Shaft.Params.Width = 8;
		Shaft.Params.Alpha = 0;
		Shaft.SetParticleParams(0, Shaft.Params);

		for (i=1; i<NumKnots; i++)
		{
			Len = VSize(End - LastPoint) / (NumKnots-i);

			Deltas[i] = VRand() * 6;

			Loc = LastPoint + (Normal(end-LastPoint) * len);
			Loc += deltas[i];

			Shaft.GetParticleParams(i,Shaft.Params);
			Shaft.Params.Position = Loc;
			Shaft.Params.Width = (3 + CastingLevel) * (1 + (i/float(NumKnots)));
			
			if (i == NumKnots)
				Shaft.Params.Alpha = 0;
			
			Shaft.SetParticleParams(i, Shaft.Params);
			LastPoint = Loc;
		}
	}

	// check for targets
	function FindTargets()
	{
		local bool 				bFound;
		local int 				i, j;

		local pawn 				PawnOwner;
		local Pawn 				tPawn;
		local siren_Particles 	Siren;

		PawnOwner = Pawn(Owner);

		if ( true )
		{

			for (i=0; i<8; i++)
				Sirens[i] = none;

			// Find any Powder of the Siren actors and add them into sirens[]
			forEach VisibleActors(class'Siren_particles',siren, 4096, Location)
			{
				bFound = true;

				for(i=0; i<8; i++)
					if ( (sirens[i] == none) && !bFound && (FastTrace(Siren.Location, Location)))
					{
						sirens[i] = siren;
						bFound = true;
					}
			}

			// Find any pawns I can put some hurt on.
			bHaveATarget = false;
					
			forEach VisibleActors(class'Pawn',tPawn, 8192, Location)
				if ( TPawn != PawnOwner && (TPawn.Health > 0) && TPawn.bCollideActors )
				{
					bHaveATarget = true;
					bFound = false;

					// already in my list?
					for (i=0; i<8; i++)
						if (Targets[i] == tPawn)
							bFound = true;

					if ( !bFound )
						for(i=0; i<8; i++)
							if ( (Targets[i] == none) && !bFound )
							{
								Targets[i] = tPawn;
								bFound = true;
							}

					for (i=0; i<8; i++)
						if ( Targets[i] != none)
							for (j=0; j<8; j++)
								if (Sirens[j] != none)
									if ( !SirenCheck(Targets[i].Location, Sirens[j].Location) )
									{
										Targets[i] = none;
										if (Shafts[i] != none)
											Shafts[i].Destroy();
									}
				}

			// check all targeted pawns
			for (i=0; i<8; i++)
			{
				if (Targets[i] != none)
				{
					if ( !FastTrace(Location, Targets[i].Location) )
					{
						Targets[i] = none;
						if ( Shafts[i] != none )
						{
							Shafts[i].Destroy();
							Shafts[i] = none;
						}
					}
				} else {
					if ( Shafts[i] != none )
					{ 
						Shafts[i].Destroy();
						Shafts[i] = none;
					}
				}
			}
			UpdateTargets();
		} else {
			Destroy();
		} 
	}
	
	function Timer()
	{
		if ( !Pawn(Owner).UseMana(2) )
			Destroy();
	}

	Begin:
		SetTimer(0.03333, true);
}

function bool SirenCheck(vector pawnLoc, vector sirenLoc)
{
	local vector v1, v2;
	local float angle;
	
	v1 = pawnLoc - Location;
	v2 = sirenLoc - Location;
	angle = v1 dot v2;
	angle = atan( sqrt(1-angle^2) / angle );
	// log("SirenCheck Angle: "$Angle);
	if ( abs(angle) < 10 )
		return true;
	
	return false;
}

simulated function Explode(vector HitLocation, vector HitNormal);
simulated function ProcessTouch (Actor Other, Vector HitLocation);

defaultproperties
{
     SuckingSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PwrSuck01'
     damagePerLevel(0)=1
     damagePerLevel(1)=1
     damagePerLevel(2)=2
     damagePerLevel(3)=2
     damagePerLevel(4)=3
     damagePerLevel(5)=3
     Damage=1
     MyDamageType=PowerWord
     MyDamageString="power worded"
     bMagical=True
     DrawType=DT_Sprite
     Style=STY_AlphaBlend
     Texture=Texture'Aeons.Spells.PwrWord'
     ShadowRange=0
     DrawScale=0.055
     SpriteProjForward=1
     SoundVolume=190
     bCollideActors=False
     bCollideWorld=False
     LightType=LT_Steady
     LightBrightness=5
     LightHue=180
     LightSaturation=128
     LightRadius=16
     VolumeBrightness=64
     VolumeRadius=20
     VolumeFog=16
     bDarkLight=True
}
