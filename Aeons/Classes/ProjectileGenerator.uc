//=============================================================================
// ProjectileGenerator.
//=============================================================================
class ProjectileGenerator expands Generator;

//#exec TEXTURE IMPORT NAME=ProjGen FILE=ProjGen.pcx GROUP=System Mips=On

var bool bActive;
var() bool bInitiallyOn;
var() class<Projectile>		ProjectileClass;		// class of creature spawned
var() class<Actor>			EffectClass;			// Effect to spawn whn fired
var() float					ProjectileSpeed;
var() name					TargetTag;
var() bool					bTriggered;				// Triggered
var() bool					bTimer;					// Trigger starts timer
var() bool					bRandomInterval;		//
var() float					TimerInterval;			// timer generation interval
var() float					TimerRandom;			// timer random factor
var(Area_Generator) float	ProjPerSec;
var() bool bRandomTarget;
var Actor Targets[32];
var() int MaxNumToFire;
var int MaxNum;
var int NumFired;
var() Sound Sound1;
var() Sound Sound2;
var() Sound Sound3;
var() float ProjectileLifeTime;

function PreBeginPlay()
{
	if (MaxNumToFire > 0)
		MaxNum = MaxNumToFire;

	super.PreBeginPlay();
}

function PlayEffectSound()
{
	local float Decision;
	
	Decision = FRand();
	
	if ( (decision > 0.66667) && (Sound3 != none) )
		PlaySound(Sound3,SLOT_Interact, 3.0 ,,1024, 1.0);
	else if ( (decision > 0.33333334) && (Sound2 != none) )
		PlaySound(Sound2,SLOT_Interact, 3.0 ,,1024, 1.0);
	else if (Sound1 != none)
		PlaySound(Sound1,SLOT_Interact, 3.0 ,,1024, 1.0);
}

state() AreaGenerator
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		if (!bActive)
		{
			bActive = true;
			setTimer( (1.0/ProjPerSec),true);
		} else {
			bActive = false;
			setTimer(0,false);
		}
	}

	function Timer()
	{
		local vector EmitLocation, r;
		
		r = VRand();
		r.z = 0;
		r = Normal(r);

		EmitLocation = Location + r * (FRand() * CollisionRadius);
		if (Level.GetZone(EmitLocation) != 0)
			genProjectile(EmitLocation, Rotation);
	}

	Begin:
		if ( bInitiallyOn )
		{
			bActive = true;
			setTimer( (1.0/ProjPerSec),true);// + (FRand() * (ProjPerSec * 0.25)),true);
		}
}


state() NormalGenerator
{
	function BeginState()
	{
		if ( bTimer && bInitiallyOn )
		{
			NumFired = 0;
			SetTimer( TimerInterval - TimerRandom + ( FRand() * TimerRandom * 2 ), true );
			bActive = true;
		} else {
			SetTimer(0, false);
			bActive = false;
		}
	}

	function Timer()
	{
		GenerateEvent();
		if ( bRandomInterval )
		{
			SetTimer( TimerInterval - TimerRandom + ( FRand() * TimerRandom * 2 ), true );
		}
	}

	// generator was triggered
	function Trigger( actor Other, pawn Instigator )
	{
		if ( bTriggered && !bTimer )
			GenerateEvent();

		if ( bTriggered && bTimer )
		{
			log("Being triggered.....bActive = "$bActive, 'Misc');
			if ( bActive )
			{
				// turn it off
				SetTimer(0, false);
				bActive = false;
			} else {
				// turn it on
				NumFired = 0;
				SetTimer( TimerInterval - TimerRandom + ( FRand() * TimerRandom * 2 ), true );
				bActive = true;
			}
		}
	}

	function GenerateEvent()
	{
		local rotator r;
		local Actor A;
		local int nt, i;
	
		if ( NumFired <= MaxNum )
		{
			if ( TargetTag != 'none' )
			{
				forEach AllActors(class 'Actor', A, TargetTag)
				{
					if ( nt < 32 )
					{
						Targets[nt] = A;
						nt ++;
					}
				}

				if ( !bRandomTarget )
				{
					for (i=0; i<nt; i++)
					{
						r = Rotator(Normal(Targets[i].Location - Location));
						genProjectile(location, r);
						NumFired ++;
					}
				} else {
					i = RandRange(0, nt);
					r = Rotator(Normal(Targets[i].Location - Location));
					genProjectile(location, r);
					NumFired ++;
				}
			} else {
				genProjectile(Location, Rotation);
				NumFired ++;
			}

			// infinitely firing?
			if ( MaxNum == 0 )
				NumFired = 0;
			PlayEffectSound();
		} else {
			bActive = false;
		}
	}

	Begin:
		
}

function genProjectile(vector Loc, rotator Rot)
{
	local Projectile P;
	
	if (ProjectileClass != none)
	{
		// Spawn the effect class if defined
		if (EffectClass != none)
			spawn(EffectClass,,,Loc);
	
		// Create the projectile
		P = spawn(ProjectileClass, self, , Loc, Rot);
		if (ProjectileLifeTime > 0)
			P.LifeSpan = ProjectileLifeTime;
		if (ProjectileSpeed > 0) P.Speed = ProjectileSpeed;
	}
}

defaultproperties
{
     InitialState=NormalGenerator
     Texture=Texture'Aeons.System.ProjGen'
     DrawScale=0.5
     bCollideActors=True
}
