class Decal expands Visible
	native;

// Decal Management
var() float Priority;		// Between 1 and 0 - works like shadowImportance
var() float DecalLifetime;	// LifeTime of the decal
var() float FadeTime;	// time it takes for the decal to fade out and destroy itself
var() bool	bAlwaysVisible;

// properties
var int MultiDecalLevel;
var float LastRenderedTime;
var float Age, AgePct;

// native stuff.
var const array<int> SurfList;

simulated native function Texture AttachDecal( float TraceDistance, optional vector DecalDir ); // trace forward and attach this decal to surfaces.
simulated native function DetachDecal(); // detach this decal from all surfaces.

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	Level.AddDecal();
}

simulated function Init()
{
	if ( DecalLifetime > 0 )
	{
		setTimer(DecalLifetime, false); 
	}
}

simulated function StartLevel()
{
	AttachToSurface();
}

simulated event PostBeginPlay()
{
	// AttachToSurface();
}

simulated function Tick( float DeltaTime )
{
	Age += DeltaTime;
	if ( DecalLifetime > 0 )
		AgePct = Age / DecalLifetime;
}

simulated function SetNewLocation(Vector Loc, vector HitNormal)
{
	DetachDecal();
	SetLocation(Loc);
	SetRotation(Rotator(HitNormal));
	AttachDecal(32, Vector(Rotation));
}

simulated function SetDrawScale(float Value)
{
	DetachDecal();
	DrawScale = Value;
	AttachDecal(32, Vector(Rotation));
}

simulated function ReattachDecal(optional Vector newRot)
{
   DetachDecal();
   if (newRot != vect(0,0,0))
      AttachDecal(32, newRot);
   else
      AttachDecal(32);
}

simulated function AttachToSurface(optional vector DecalDir)
{
	if (Level.NetMode == NM_DedicatedServer) // decals can't be attached on a dedicated server because of GetLevel()->Engine->Client check
		return;
	
	if( AttachDecal(100, DecalDir) == None )	// trace 100 units ahead in direction of current rotation
	{
		Destroy();
	}
}

simulated event Destroyed()
{
	DetachDecal();
	Level.RemoveDecal();
	Super.Destroyed();
}

simulated function Timer()
{
	gotoState('FadeOut');
}

auto simulated state Startup
{

	Begin:
		Sleep(0.25);
		Init();
		GotoState('');
}

simulated state FadeOut
{
	simulated function Tick(float DeltaTime)
	{
		if (FadeTime > 0)
		{
			Opacity = FClamp((Opacity - (DeltaTime / FadeTime)), 0, 1);
			// ReattachDecal(Vector(Rotation));
		}
	}

	simulated function Timer()
	{
		Destroy();
	}

	Begin:
		setTimer(FadeTime,false);
}

simulated function SoftLimitReached()
{
	if ( (GetStateName() != 'FadeOut') && !bScryeOnly && !bAlwaysVisible )
	{
		FadeTime = 1;
		GotoState('FadeOut');
	}
}

simulated function HardLimitReached()
{
	if ( (GetStateName() != 'FadeOut') && !bScryeOnly && !bAlwaysVisible )
	{
		FadeTime = 0.25;
		GotoState('FadeOut');
	}
}

event Update(Actor L);

simulated function ShutDown();

defaultproperties
{
     MultiDecalLevel=4
     bHighDetail=True
     bNetTemporary=True
     bNetOptional=True
     bTimedTick=True
     MinTickTime=0.05
     RemoteRole=ROLE_None
     DrawType=DT_None
     Style=STY_Modulated
     bUnlit=True
     bGameRelevant=True
     CollisionRadius=0
     CollisionHeight=0
}
